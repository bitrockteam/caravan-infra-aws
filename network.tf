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

resource "aws_lb" "hashicorp_alb" {
  name               = "hashicorp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Project = var.prefix
  }
}

// aws_lb_listener
resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.hashicorp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "aws_acm_certificate" "cert" {
  private_key       = tls_private_key.cert_private_key.private_key_pem
  certificate_body  = module.terraform_acme_le.certificate_pem
  certificate_chain = module.terraform_acme_le.issuer_pem

  tags = {
    Project = var.prefix
  }
}

resource "aws_lb_listener" "https_443" {
  load_balancer_arn = aws_lb.hashicorp_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress.arn
  }
}

// aws_lb_target_group
resource "aws_lb_target_group" "vault" {
  name     = "hashicorp-target-group-vault"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol = "HTTP"
    matcher  = "200"
    path     = "/v1/sys/leader"
  }

  tags = {
    Project = var.prefix
  }
}
resource "aws_lb_target_group" "consul" {
  name     = "hashicorp-target-group-consul"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol = "HTTP"
    matcher  = "200"
    path     = "/v1/sys/leader"
  }

  tags = {
    Project = var.prefix
  }
}
resource "aws_lb_target_group" "nomad" {
  name     = "hashicorp-target-group-nomad"
  port     = 4646
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol = "HTTP"
    matcher  = "200"
    path     = "/v1/sys/leader"
  }

  tags = {
    Project = var.prefix
  }
}
resource "aws_lb_target_group" "ingress" {
  name     = "hashicorp-target-group-ingress"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol = "HTTP"
    matcher  = "200,404"
  }

  tags = {
    Project = var.prefix
  }
}

// aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "vault" {
  count            = var.control_plane_instance_count
  target_group_arn = aws_lb_target_group.vault.arn
  target_id        = aws_instance.hashicorp_cluster[count.index].id
  port             = 8200
}
resource "aws_lb_target_group_attachment" "consul" {
  count            = var.control_plane_instance_count
  target_group_arn = aws_lb_target_group.consul.arn
  target_id        = aws_instance.hashicorp_cluster[count.index].id
  port             = 8500
}
resource "aws_lb_target_group_attachment" "nomad" {
  count            = var.control_plane_instance_count
  target_group_arn = aws_lb_target_group.nomad.arn
  target_id        = aws_instance.hashicorp_cluster[count.index].id
  port             = 4646
}

// aws_lb_listener_rule
resource "aws_lb_listener_rule" "vault" {
  listener_arn = aws_lb_listener.https_443.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }

  condition {
    host_header {
      values = ["vault.${var.prefix}.${var.external_domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "consul" {
  listener_arn = aws_lb_listener.https_443.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consul.arn
  }

  condition {
    host_header {
      values = ["consul.${var.prefix}.${var.external_domain}"]
    }
  }
}

resource "aws_lb_listener_rule" "nomad" {
  listener_arn = aws_lb_listener.https_443.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nomad.arn
  }

  condition {
    host_header {
      values = ["nomad.${var.prefix}.${var.external_domain}"]
    }
  }
}
