module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr

  azs             = [join("", [var.region, "a"]), join("", [var.region, "b"]), join("", [var.region, "c"])]
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_ipv6            = false
  tags = {
    Project = var.prefix
  }
  vpc_tags = {
    Name    = "${var.prefix}-vpc"
    Project = var.prefix
  }
}

resource "aws_security_group" "allow_cluster_ssh" {
  name        = join("_", [var.prefix, "hashicorp_cluster_ssh_in"])
  description = "Allow Hashicorp Cluster Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    description = "ping"
    cidr_blocks = var.personal_ip_list
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "ssh internal"
    cidr_blocks = var.personal_ip_list
  }

  tags = {
    Name    = join("_", [var.prefix, "hashicorp_cluster_ssh_in"])
    Project = var.prefix
  }
}

resource "aws_security_group" "hashicorp_cluster" {
  name        = join("_", [var.prefix, "hashicorp_cluster_in"])
  description = "Allow Hashicorp Cluster Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    from_port   = 4646
    to_port     = 4646
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name    = join("_", [var.prefix, "hashicorp_cluster_in"])
    Project = var.prefix
  }

}


resource "aws_security_group" "hashicorp_internal_vault" {
  name        = join("_", [var.prefix, "hashicorp_internal_vault_in"])
  description = "Allow Hashicorp Vault Internal Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name      = join("_", [var.prefix, "hashicorp_cluster_in"])
    Project   = var.prefix
    Component = "vault"
  }

}
resource "aws_security_group" "hashicorp_internal_consul" {
  name        = join("_", [var.prefix, "hashicorp_internal_consul_in"])
  description = "Allow Hashicorp Consul Internal Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 8502
    to_port     = 8502
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name      = join("_", [var.prefix, "hashicorp_cluster_in"])
    Project   = var.prefix
    Component = "consul"
  }

}
resource "aws_security_group" "hashicorp_internal_nomad" {
  name        = join("_", [var.prefix, "hashicorp_internal_nomad_in"])
  description = "Allow Hashicorp Nomad Internal Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 4646
    to_port     = 4646
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 4647
    to_port     = 4647
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 4648
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name      = join("_", [var.prefix, "hashicorp_cluster_in"])
    Project   = var.prefix
    Component = "nomad"
  }

}