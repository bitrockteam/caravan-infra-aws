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
  default = "aws_dc"
}
variable "le_endpoint" {
  type = string
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