terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    acme = {
      source = "vancluever/acme"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = "~> 1.0"
}
