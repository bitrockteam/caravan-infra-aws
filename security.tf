
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

resource "aws_security_group" "allow_outgoing_all" {
  name        = join("_", [var.prefix, "hashicorp_outgoing_all"])
  description = "Allow Outgoing Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    description = "ping"
    cidr_blocks = var.personal_ip_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = join("_", [var.prefix, "hashicorp_outgoing_all"])
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = join("_", [var.prefix, "hashicorp_cluster_in"])
    Project = var.prefix
  }

}

resource "aws_security_group" "alb_security" {
  name        = join("_", [var.prefix, "hashicorp_internal_alb_in"])
  description = "Allow Hashicorp ALB Internal Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 4646
    to_port     = 4646
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
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
    from_port   = 8501
    to_port     = 8501
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