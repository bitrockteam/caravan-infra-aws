
##########################
#Query for most recent AMI of type debian
##########################

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-hvm-x86_64-*"]
  }

  owners = ["379101102735"] # Debian
}

############################
#Launch configuration for service host
############################

resource "aws_launch_configuration" "bastion-service-host" {
  name_prefix                 = "${var.prefix}-bastion-host"
  image_id                    = data.aws_ami.debian.id
  instance_type               = "t3.micro"
  associate_public_ip_address = false
  security_groups             = [aws_security_group.allow_cluster_basics.id]
  key_name                    = aws_key_pair.hashicorp_keypair.key_name

  root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#######################################################
# ASG section
#######################################################

resource "aws_autoscaling_group" "bastion-service" {
  name_prefix          = "${var.prefix}-bastion-asg"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.bastion-service-host.name
  vpc_zone_identifier  = module.vpc.private_subnets
  target_group_arns    = [aws_lb_target_group.bastion-service.arn]

  tags = [
    {
      key                 = "Name"
      value               = "${var.prefix}-bastion"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}

####################################################
# DNS Section
###################################################

resource "aws_route53_record" "bastion" {
  zone_id = aws_route53_zone.hashicorp_zone.zone_id
  name    = "bastion.${var.prefix}.${var.external_domain}"
  type    = "CNAME"
  ttl     = "5"

  records = [aws_lb.hashicorp_nlb.dns_name]
}


# LB
resource "aws_lb_listener" "bastion-service" {
  load_balancer_arn = aws_lb.hashicorp_nlb.arn
  protocol          = "TCP"
  port              = "22"

  default_action {
    target_group_arn = aws_lb_target_group.bastion-service.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "bastion-service" {
  name        = "${var.prefix}-bastion"
  protocol    = "TCP"
  port        = 22
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "TCP"
    port                = 22
  }

  tags = {
    Project = var.prefix
  }
}
