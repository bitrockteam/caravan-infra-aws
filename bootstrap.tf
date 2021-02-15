module "caravan-bootstrap" {
  source                         = "git::ssh://git@github.com/bitrockteam/caravan-bootstrap?ref=main"
  ssh_private_key                = chomp(tls_private_key.ssh_key.private_key_pem)
  ssh_user                       = "centos"
  ssh_timeout                    = "240s"
  control_plane_nodes_ids        = [for n in aws_instance.hashicorp_cluster : n.tags["Name"]]
  control_plane_nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  control_plane_nodes_public_ips = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
  tcp_listener_tls               = false
  dc_name                        = var.dc_name
  prefix                         = var.prefix
  vault_endpoint                 = "http://127.0.0.1:8200"
  control_plane_role_name        = local.control_plane_role_name

  unseal_type          = "aws"
  agent_auto_auth_type = "aws"

  aws_region     = var.region
  aws_kms_key_id = aws_kms_key.vault.id
  aws_node_role  = local.control_plane_role_name
}
