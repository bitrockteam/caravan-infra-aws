plugin "aws" {
  enabled = true
  version = "0.15.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
config {
  module = true
}
