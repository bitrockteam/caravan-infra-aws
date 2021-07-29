locals {
  control_plane_role_name = "control-plane"
  worker_plane_role_name  = "worker-plane"
}

module "cloud_init_control_plane" {
  source                   = "git::https://github.com/bitrockteam/caravan-cloudinit?ref=refs/tags/v0.1.13"
  cluster_nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  vault_endpoint           = "http://127.0.0.1:8200"
  dc_name                  = var.dc_name
  auto_auth_type           = "aws"
  aws_node_role            = local.control_plane_role_name
  partition_prefix         = "p"
  vault_persistent_device  = "/dev/sdd"
  consul_persistent_device = "/dev/sde"
  nomad_persistent_device  = "/dev/sdf"
}

module "cloud_init_worker_plane" {
  source         = "git::https://github.com/bitrockteam/caravan-cloudinit?ref=refs/tags/v0.1.9"
  cluster_nodes  = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  vault_endpoint = "http://${aws_instance.hashicorp_cluster[0].private_ip}:8200"
  dc_name        = var.dc_name
  auto_auth_type = "aws"
  aws_node_role  = local.worker_plane_role_name
}
