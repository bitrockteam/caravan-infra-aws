# AWS params
variable "awsprofile" {
  type        = string
  description = "AWS user profile"
}
variable "shared_credentials_file" {
  type        = string
  description = "AWS credential file path"
}
variable "region" {
  type        = string
  description = "AWS region to use"
}
variable "personal_ip_list" {
  type        = list(string)
  description = "IP address list for SSH connection to the VMs"
}
variable "prefix" {
  type        = string
  description = "The prefix of the objects' names"
}
variable "tfstate_bucket_name" {
  type        = string
  default     = ""
  description = "S3 Bucket where Terraform state is stored"
}
variable "tfstate_table_name" {
  type        = string
  default     = ""
  description = "DynamoDB Table where Terraform state lock is acquired"
}
variable "tfstate_region" {
  type        = string
  default     = ""
  description = "AWS Region where Terraform state resources are"
}
# AWS Compute
variable "ami_filter_name" {
  type        = string
  default     = "caravan-os-ubuntu-2204*"
  description = "Regexp to find AMI to use built with caravan-baking"
}
variable "control_plane_instance_count" {
  type        = number
  default     = 3
  description = "Control plane instances number"
}
variable "workers_group_size" {
  type        = number
  default     = 3
  description = "Worker plane instances number"
}
variable "enable_nomad" {
  type        = bool
  default     = true
  description = "Enables and setup Nomad cluster"
}
variable "csi_volumes" {
  type        = map(map(string))
  default     = {}
  description = <<EOF
Example:
{
  "jenkins" : {
    "availability_zone" : "eu-west-1a"
    "size" : "30"
    "type" : "gp3"
    "tags" : { "application": "jenkins_master" }
  }
}
EOF
}


variable "volume_root_size" {
  type        = number
  default     = 20
  description = "Volume size of control plan root disk"
}

variable "volume_data_size" {
  type        = number
  default     = 20
  description = "Volume size of control plan data disk"
}

variable "volume_type" {
  type        = string
  default     = "gp3"
  description = "Volume type of disks"
}

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Enable monitoring"
}
variable "volume_size" {
  type        = number
  default     = 100
  description = "Volume size of workers disk"
}
variable "control_plane_machine_type" {
  type        = string
  default     = "t3.micro"
  description = "Control plane instance machine type"
}
variable "worker_plane_machine_type" {
  type        = string
  default     = "t3.large"
  description = "Working plane instance machine type"
}
variable "monitoring_machine_type" {
  type        = string
  default     = "t3.xlarge"
  description = "Monitoring instance machine type"
}
# AWS Network
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC cidr"
}
variable "vpc_private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "VCP private subnets"
}
variable "vpc_public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "VCP public subnets"
}

variable "ports" {
  type = map(number)
  default = {
    http  = 80
    https = 443
  }
}

# Hashicorp params
variable "dc_name" {
  type    = string
  default = "aws-dc"
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*)+$", var.dc_name))
    error_message = "Invalid dc_name. Must contain letters, numbers and hyphen."
  }
  description = "Hashicorp cluster name"
}
variable "use_le_staging" {
  type        = bool
  default     = true
  description = "Use staging Let's Encrypt endpoint"
}
variable "external_domain" {
  type        = string
  default     = ""
  description = "Domain used for endpoints and certs"
}
variable "ca_certs" {
  type = map(object({
    filename = string
    pemurl   = string
  }))
  default = {
    stg-int-r3 = {
      filename = "letsencrypt-stg-int-r3.pem"
      pemurl   = "https://letsencrypt.org/certs/staging/letsencrypt-stg-int-r3.pem"
    },
    stg-root-x1 = {
      filename = "letsencrypt-stg-root-x1.pem"
      pemurl   = "https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem"
    }
  }
  description = "Fake certificates from staging Let's Encrypt"
}

variable "vault_license_file" {
  type        = string
  default     = null
  description = "Path to Vault Enterprise license"
}
variable "consul_license_file" {
  type        = string
  default     = null
  description = "Path to Consul Enterprise license"
}
variable "nomad_license_file" {
  type        = string
  default     = null
  description = "Path to Nomad Enterprise license"
}

variable "ssh_username" {
  type        = string
  description = "centos or ubuntu ssh user for bootstrap"
}
