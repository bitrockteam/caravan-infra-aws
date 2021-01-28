locals {
  control_plane_role_name = "control-plane"
  worker_plane_role_name  = "worker-plane"
}

module "cloud_init_control_plane" {
  source         = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-cloudinit"
  cluster_nodes  = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  vault_endpoint = "http://127.0.0.1:8200"
  dc_name        = var.dc_name
  auto_auth_type = "aws"
  aws_node_role  = local.control_plane_role_name
}

module "cloud_init_worker_plane" {
  source         = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-cloudinit"
  cluster_nodes  = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  vault_endpoint = "http://${aws_instance.hashicorp_cluster[0].private_ip}:8200"
  dc_name        = var.dc_name
  auto_auth_type = "aws"
  aws_node_role  = local.worker_plane_role_name
}