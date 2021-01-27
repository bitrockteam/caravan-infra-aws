module "vault_cluster" {
  source                   = "git::ssh://git@github.com/bitrockteam/hashicorp-vault-baseline//modules/cluster-raft?ref=master"
  cluster_nodes_ids        = [for n in aws_instance.hashicorp_cluster : n.tags["Name"]]
  cluster_nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  cluster_nodes_public_ips = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
  ssh_private_key          = tls_private_key.ssh-key.private_key_pem
  ssh_user                 = "centos"
  ssh_timeout              = "240s"
  unseal_type              = "aws"
  aws_kms_region           = var.region
  aws_kms_key_id           = aws_kms_key.vault.id
  prefix                   = var.prefix
}

module "vault_cluster_agents" {
  source           = "git::ssh://git@github.com/bitrockteam/hashicorp-vault-baseline//modules/agent?ref=master"
  vault_endpoint   = "http://127.0.0.1:8200"
  tcp_listener_tls = false
  nodes_ids        = [for n in aws_instance.hashicorp_cluster : n.tags["Name"]]
  nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  nodes_public_ips = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
  ssh_private_key  = tls_private_key.ssh-key.private_key_pem
  ssh_user         = "centos"
  ssh_timeout      = "240s"
}

module "consul-cluster" {
  source                   = "git::ssh://git@github.com/bitrockteam/hashicorp-consul-baseline//modules/consul-cluster?ref=master"
  ssh_private_key          = tls_private_key.ssh-key.private_key_pem
  cluster_nodes_ids        = [for n in aws_instance.hashicorp_cluster : n.tags["Name"]]
  cluster_nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  cluster_nodes_public_ips = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
  vault_address            = module.vault_cluster.vault_address
  dc_name                  = var.dc_name
}

module "nomad-cluster" {
  pre13_depends_on = [
    module.vault_cluster,
    module.consul-cluster
  ]
  source                   = "git::ssh://git@github.com/bitrockteam/hashicorp-nomad-baseline//modules/nomad-cluster?ref=master"
  ssh_private_key          = tls_private_key.ssh-key.private_key_pem
  cluster_nodes_ids        = [for n in aws_instance.hashicorp_cluster : n.tags["Name"]]
  cluster_nodes            = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.private_ip }
  cluster_nodes_public_ips = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
  dc_name                  = var.dc_name
}