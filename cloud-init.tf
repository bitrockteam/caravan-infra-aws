module "cloud-init" {
    source = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-cloudinit"
    cluster_nodes = { for n in aws_instance.hashicorp_cluster: n.tags["Name"] => n.private_ip }
    vault_endpoint = "vault_endpoint.internal"
    dc_name = var.dc_name
}