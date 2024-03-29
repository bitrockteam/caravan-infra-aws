module "caravan-bootstrap" {
  source                         = "git::https://github.com/bitrockteam/caravan-bootstrap?ref=refs/tags/v0.2.14"
  ssh_private_key                = chomp(tls_private_key.ssh_key.private_key_pem)
  ssh_user                       = var.ssh_username
  ssh_bastion_host               = aws_lb.hashicorp_nlb.dns_name
  ssh_bastion_private_key        = chomp(tls_private_key.ssh_key.private_key_pem)
  ssh_bastion_user               = "admin"
  ssh_timeout                    = "240s"
  control_plane_nodes_ids        = [for n in aws_instance.hashicorp_cluster : n.arn]
  control_plane_nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  control_plane_nodes_public_ips = null
  tcp_listener_tls               = false
  dc_name                        = var.dc_name
  prefix                         = var.prefix
  external_domain                = var.external_domain
  vault_endpoint                 = "http://127.0.0.1:8200"
  control_plane_role_name        = local.control_plane_role_name
  enable_nomad                   = var.enable_nomad

  unseal_type          = "aws"
  agent_auto_auth_type = "aws"

  aws_region     = var.region
  aws_kms_key_id = aws_kms_key.vault.id
  aws_node_role  = local.control_plane_role_name

  consul_license = var.consul_license_file != null ? file(var.consul_license_file) : ""
  vault_license  = var.vault_license_file != null ? file(var.vault_license_file) : ""
  nomad_license  = var.nomad_license_file != null && var.enable_nomad ? file(var.nomad_license_file) : ""

  depends_on = [
    aws_volume_attachment.vault_cluster_ec2,
    aws_volume_attachment.consul_cluster_ec2,
    aws_volume_attachment.nomad_cluster_ec2
  ]
}
