#!/usr/bin/env bash

NAME=$1
REGION=$2
PROFILE=$3

BUCKET_NAME=$NAME-terraform-state
TABLE_NAME=$NAME-terraform-state-lock
CLOUD_NAME=aws
PREFIX=$NAME

echo -e "\033[32mCreating S3 Bucket $BUCKET_NAME\033[0m"
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --create-bucket-configuration "LocationConstraint=$REGION" \
  --profile "$PROFILE"
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --versioning-configuration Status=Enabled \
  --profile "$PROFILE"

echo -e "\033[32mCreating DynamoDB Table $TABLE_NAME\033[0m"
aws dynamodb create-table \
  --region "$REGION" \
  --table-name "$TABLE_NAME" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema KeyType=HASH,AttributeName=LockID \
  --billing-mode PAY_PER_REQUEST \
  --profile "$PROFILE"

echo -e "\033[32mWrite tfvars and backend files.\033[0m"
cat <<EOT > aws.tfvars
region                  = "${REGION}"
awsprofile              = "${PROFILE}"
shared_credentials_file = "~/.aws/credentials"
prefix                  = "${NAME}"
personal_ip_list        = ["0.0.0.0/0"]
use_le_staging          = true
external_domain         = "my-real-domain.io"
tfstate_bucket_name     = "${BUCKET_NAME}"
tfstate_table_name      = "${TABLE_NAME}"
tfstate_region          = "${REGION}"
EOT

cat <<EOT > backend.tf
terraform {
  backend "s3" {
    bucket         = "${BUCKET_NAME}"
    key            = "infraboot/terraform/state/terraform.tfstate"
    region         = "${REGION}"
    dynamodb_table = "${TABLE_NAME}"
  }
}
EOT


cat <<EOT > run.sh
#!/usr/bin/env bash
set -e

EXTERNAL_DOMAIN="example.com" # replace
export VAULT_ADDR="https://vault.${PREFIX}.\${EXTERNAL_DOMAIN}"
export CONSUL_ADDR="https://consul.${PREFIX}.\${EXTERNAL_DOMAIN}"
export NOMAD_ADDR="https://nomad.${PREFIX}.\${EXTERNAL_DOMAIN}"

DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Deploying infrastructure..."

terraform init -reconfigure -upgrade
terraform apply -var-file ${CLOUD_NAME}.tfvars -auto-approve

echo "Waiting for Vault \${VAULT_ADDR} to be up..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${VAULT_ADDR}/v1/sys/leader") != "200" ]; do
  echo "Waiting for Vault to be up..."
  sleep 5
done

echo "Waiting for Consul \${CONSUL_ADDR} to be up..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${CONSUL_ADDR}/v1/status/leader") != "200" ]; do
  echo "Waiting for Consul to be up..."
  sleep 5
done

echo "Waiting for Nomad \${NOMAD_ADDR} to be up..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${NOMAD_ADDR}/v1/status/leader") != "200" ]; do
  echo "Waiting for Nomad to be up..."
  sleep 5
done

export VAULT_TOKEN=\$(cat ".${PREFIX}-root_token")
export NOMAD_TOKEN=\$(vault read -tls-skip-verify -format=json nomad/creds/token-manager | jq -r .data.secret_id)

echo "Configuring platform..."

cd "\$DIR/../caravan-platform"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform apply -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Waiting for Consul Connect to be ready..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${CONSUL_ADDR}/v1/connect/ca/roots") != "200" ]; do
  echo "Waiting for Consul Connect to be ready..."
  sleep 5
done

echo "Configuring application support..."

cd "\$DIR/../caravan-application-support"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform apply -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

cd "\$DIR"

echo "Done."
EOT

cat <<EOT > destroy.sh
#!/usr/bin/env bash
set -e

EXTERNAL_DOMAIN="example.com" # replace
export VAULT_ADDR="https://vault.${PREFIX}.\${EXTERNAL_DOMAIN}"
export CONSUL_ADDR="https://consul.${PREFIX}.\${EXTERNAL_DOMAIN}"
export NOMAD_ADDR="https://nomad.${PREFIX}.\${EXTERNAL_DOMAIN}"

DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export VAULT_TOKEN=\$(cat ".${PREFIX}-root_token")
export NOMAD_TOKEN=\$(vault read -tls-skip-verify -format=json nomad/creds/token-manager | jq -r .data.secret_id)

echo "Destroying application support..."

cd "\$DIR/../caravan-application-support"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform destroy -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Destroying platform..."

cd "\$DIR/../caravan-platform"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform destroy -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Destroying infrastructure..."

cd "\$DIR"

terraform init -reconfigure -upgrade
terraform destroy -var-file ${CLOUD_NAME}.tfvars -auto-approve

echo "Done."
EOT

chmod +x run.sh
chmod +x destroy.sh

echo -e "\033[All set, review configs and execute 'run.sh' and 'destroy.sh'. Enjoy!\033[0m"
