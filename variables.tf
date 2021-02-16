variable "region" {
  type = string
}
variable "awsprofile" {
  type = string
}
variable "prefix" {
  type = string
}
variable "shared_credentials_file" {
  type = string
}
variable "personal_ip_list" {
  type = list(string)
}
variable "cluster_instance_count" {
  default = 3
}
variable "workers_group_size" {
  default = "3"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
variable "dc_name" {
  type    = string
  default = "aws-dc"
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*)+$", var.dc_name))
    error_message = "Invalid dc_name. Must contain letters, numbers and hyphen."
  }
}
variable "use_le_staging" {
  type    = bool
  default = true
}
variable "external_domain" {
  type    = string
  default = ""
}
variable "ca_certs" {
  type = map(object({
    filename = string
    pemurl   = string
  }))
  default = {
    fakeleintermediatex1 = {
      filename = "fakeleintermediatex1.pem"
      pemurl   = "https://letsencrypt.org/certs/fakeleintermediatex1.pem"
    },
    fakelerootx1 = {
      filename = "fakelerootx1.pem"
      pemurl   = "https://letsencrypt.org/certs/fakelerootx1.pem"
    }
  }
}

variable "aws_csi" {
  type        = bool
  description = "provision csi disks"
  default     = true
}
variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "volume_size" {
  type    = number
  default = 100
}
variable "control_plane_machine_type" {
  type    = string
  default = "t2.micro"
}
variable "worker_plane_machine_type" {
  type    = string
  default = "t3.small"
}
variable "monitoring_machine_type" {
  type    = string
  default = "t2.large"
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