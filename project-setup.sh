#!/usr/bin/env bash

NAME=$1
REGION=$2
PROFILE=$3

BUCKET_NAME=$NAME-terraform-state
TABLE_NAME=$NAME-terraform-state-lock

echo -e "\033[32mCreating S3 Bucket $BUCKET_NAME\033[0m"
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
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
aws_csi                 = true
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

echo -e "\033[32mDone!\033[0m"
