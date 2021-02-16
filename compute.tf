data "aws_ami" "centos7" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["*hashicorp-centos-image-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "product-code"
    values = ["cvugziknvmxgqna9noibqnnsy"]
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "ssh-key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "hashicorp_keypair" {
  key_name   = "hashicorp_shared_sshkey"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "hashicorp_cluster" {
  count = var.control_plane_instance_count

  ami           = data.aws_ami.centos7.id
  instance_type = var.control_plane_machine_type
  subnet_id     = module.vpc.public_subnets[count.index]
  key_name      = aws_key_pair.hashicorp_keypair.key_name

  user_data = module.cloud_init_control_plane.control_plane_user_data

  root_block_device {
    delete_on_termination = true
    tags = {
      Name    = format("clustnode%.2d", count.index + 1)
      Project = var.prefix
    }
  }

  vpc_security_group_ids = [
    aws_security_group.allow_cluster_basics.id,
    aws_security_group.internal_vault.id,
    aws_security_group.internal_consul.id,
    aws_security_group.internal_nomad.id,
    aws_security_group.internal_workers.id,
  ]

  associate_public_ip_address = true
  ebs_optimized               = false
  iam_instance_profile        = aws_iam_instance_profile.control_plane.id

  tags = {
    Name    = format("clustnode%.2d", count.index + 1)
    Project = var.prefix
  }
}

resource "aws_launch_template" "hashicorp_workers" {
  image_id      = data.aws_ami.centos7.id
  instance_type = var.worker_plane_machine_type
  key_name      = aws_key_pair.hashicorp_keypair.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.worker_plane.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      volume_size           = var.volume_size
    }
  }

  vpc_security_group_ids = [
    aws_security_group.allow_cluster_basics.id,
    aws_security_group.internal_vault.id,
    aws_security_group.internal_consul.id,
    aws_security_group.internal_nomad.id,
    aws_security_group.internal_workers.id,
  ]

  user_data = module.cloud_init_worker_plane.worker_plane_user_data

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "hashicorp-worker"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "hashicorp-worker"
    }
  }
}

resource "aws_autoscaling_group" "hashicorp_workers" {
  desired_capacity = var.workers_group_size
  max_size         = var.workers_group_size
  min_size         = 1

  vpc_zone_identifier = module.vpc.public_subnets

  target_group_arns = [aws_lb_target_group.ingress.arn]

  launch_template {
    id      = aws_launch_template.hashicorp_workers.id
    version = aws_launch_template.hashicorp_workers.latest_version
  }

  tag {
    key                 = "Project"
    value               = var.prefix
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

resource "aws_instance" "monitoring" {
  count = var.enable_monitoring ? 1 : 0

  ami           = data.aws_ami.centos7.id
  instance_type = var.monitoring_machine_type
  subnet_id     = module.vpc.public_subnets[count.index]
  key_name      = aws_key_pair.hashicorp_keypair.key_name

  user_data = module.cloud_init_worker_plane.monitoring_user_data

  root_block_device {
    delete_on_termination = true
    tags = {
      Name    = "monitoring"
      Project = var.prefix
    }
  }

  vpc_security_group_ids = [
    aws_security_group.allow_cluster_basics.id,
    aws_security_group.internal_vault.id,
    aws_security_group.internal_consul.id,
    aws_security_group.internal_nomad.id,
    aws_security_group.internal_workers.id,
  ]

  associate_public_ip_address = true
  ebs_optimized               = false
  iam_instance_profile        = aws_iam_instance_profile.worker_plane.id

  tags = {
    Name    = "monitoring"
    Project = var.prefix
  }
}
