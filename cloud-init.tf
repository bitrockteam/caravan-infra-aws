module "cloud-init" {
  source         = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-cloudinit"
  cluster_nodes  = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  vault_endpoint = "http://${aws_instance.hashicorp_cluster[0].private_ip}:8200"
  dc_name        = var.dc_name
  auto_auth_type = "aws"
  aws_region     = var.region
  aws_node_role  = "test"
}