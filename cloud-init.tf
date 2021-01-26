module "cloud-init" {
  source         = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-cloudinit"
  cluster_nodes  = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  vault_endpoint = aws_instance.hashicorp_cluster[0].private_ip
  dc_name        = var.dc_name
}