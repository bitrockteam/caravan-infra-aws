# hashicorp-terraform-infra-aws

## Prerequisites

- AWS Credentials file at `~/.aws/credentials` like
```
[default]
aws_access_key_id=AKIAJPZXVYEXAMPLE
aws_secret_access_key=4k6ZilhMPdshU6/kuwEExAmPlE
```
- Create `aws.tfvars` file with
```hcl
region                  = "eu-central-1"       # region of choice
shared_credentials_file = "~/.aws/credentials" # AWS credentials file path
awsprofile              = "default"            # AWS credentials profile name
prefix                  = "hashicorp"          # prefix for resource names
personal_ip_list        = ["0.0.0.0/0"]        # whitelist ips for remote connection
use_le_staging          = true                 # whether to use LE staging or production endpoint 
external_domain         = "my-domain.io"       # an existing route53 public zone. A new zone named ${prefix}.${external_domain} will be created in route53 containing all needed entries
```
- Create `backend.tf` file with the chosen Terraform state backend, such as
```hcl
terraform {
  backend "s3" {
    bucket         = "my-bucket"                  # existing S3 bucket
    key            = "path/to/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "my-dynamodb-table"          # existing dynamo db table
  }
}
```

## Running

```shell
terraform apply --var-file aws.tfvars
```
