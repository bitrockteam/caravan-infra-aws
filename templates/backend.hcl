
terraform {
  backend "s3" {
    bucket         = "${bucket_name}"
    key            = "${key}/terraform/state/terraform.tfstate"
    region         = "${region}"
    dynamodb_table = "${table_name}"
  }
}
