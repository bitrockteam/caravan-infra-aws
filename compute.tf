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

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "sshkey" {
  content         = tls_private_key.ssh-key.private_key_pem
  filename        = "ssh-key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "hashicorp-keypair" {
  key_name   = "hashicorp_shared_sshkey"
  public_key = tls_private_key.ssh-key.public_key_openssh
}

data "cloudinit_config" "agents-configs" {
  gzip = true
  base64_encode = true
  
  part {
    content_type = "text/x-shellscript"
    content = file("${path.module}/scripts/startup-script.sh")
    filename = "startup-script.sh"
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(templatefile("${path.module}/files/agent.hcl.tpl",
  {
    vault_endpoint      = "test:8200"
    tcp_listener        = "127.0.0.1:8200"
    tcp_listener_tls    = false
  }
))},
    encoding: b64
    owner: root:root
    path: /etc/vault.d/agent.hcl
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(templatefile("${path.module}/files/consul-agent.hcl.tmpl",
  {
    cluster_nodes = {for n in aws_instance.hashicorp_cluster: n.tags["Name"] => n.private_ip},
    dc_name       = var.dc_name
  }
))},
    encoding: b64
    owner: root:root
    path: /etc/consul.d/consul-agent.hcl
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/ca.tmpl"))},
    encoding: b64
    owner: root:root
    path: /etc/consul.d/ca.tmpl
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/cert.tmpl"))},
    encoding: b64
    owner: root:root
    path: /etc/consul.d/cert.tmpl
    permissions: '0750'
EOF
  }
  
  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/keyfile.tmpl"))},
    encoding: b64
    owner: root:root
    path: /etc/consul.d/keyfile.tmpl
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(templatefile("${path.module}/files/nomad-client.hcl.tmpl",
  {
    cluster_nodes = {},
    dc_name       = var.dc_name
    envoy_proxy_image = "asfdas"
  }
))},
    encoding: b64
    owner: root:root
    path: /etc/nomad.d/nomad-client.hcl
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/nomad-ca.tmpl"))},
    encoding: b64
    owner: root:root
    path: /etc/nomad.d/nomad_ca.tmpl
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/nomad-cert.tmpl"))},
    encoding: b64
    owner: root:root
    path: /etc/nomad.d/nomad_cert.tmpl
    permissions: '0750'
EOF
  }
  
  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/nomad-keyfile.tmpl"))},
    encoding: b64
    owner: root:root
    path: /etc/nomad.d/nomad_keyfile.tmpl
    permissions: '0750'
EOF
  }
}

resource "aws_instance" "hashicorp_cluster" {
  count = var.cluster_instance_count

  ami           = data.aws_ami.centos7.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[count.index]
  key_name      = aws_key_pair.hashicorp-keypair.key_name

  # user_data = data.cloudinit_config.startup-script.rendered

  # network_interface {
  #   network_interface_id = aws_network_interface.private_ip[count.index].id
  #   device_index = 0
  # }

  vpc_security_group_ids = [
    aws_security_group.allow_cluster_ssh.id,
    aws_security_group.hashicorp_cluster.id,
    aws_security_group.hashicorp_internal_vault.id,
    aws_security_group.hashicorp_internal_consul.id,
    aws_security_group.hashicorp_internal_nomad.id,
  ]

  associate_public_ip_address = true
  ebs_optimized               = false
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-unseal.id

  tags = {
    Name    = format("clustnode%.2d", count.index + 1)
    Project = var.prefix
  }
}

# resource "aws_network_interface" "private_ip" {
#   count = var.cluster_instance_count
#   subnet_id       = module.vpc.public_subnets[count.index]
# }
