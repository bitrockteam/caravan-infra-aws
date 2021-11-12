output "control_plane_role_name" {
  value       = local.control_plane_role_name
  description = "Control plane role name"
}
output "worker_plane_role_name" {
  value       = local.worker_plane_role_name
  description = "Worker plane role name"
}
output "control_plane_iam_role_arns" {
  value       = [aws_iam_role.control_plane.arn]
  description = "Control plane iam role list"
}
output "worker_plane_iam_role_arns" {
  value       = [aws_iam_role.worker_plane.arn]
  description = "Worker plane iam role list"
}
output "region" {
  value       = var.region
  description = "AWS region"
}
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}
output "cluster_public_ips" {
  value       = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
  description = "Control plane public IP addresses"
}
output "load_balancer_ip_address" {
  value       = aws_lb.hashicorp_nlb.dns_name
  description = "Load Balancer IP address"
}
output "hashicorp_endpoints" {
  value = var.enable_nomad ? {
    vault  = "https://vault.${var.prefix}.${var.external_domain}"
    consul = "https://consul.${var.prefix}.${var.external_domain}"
    nomad  = "https://nomad.${var.prefix}.${var.external_domain}"
    } : {
    vault  = "https://vault.${var.prefix}.${var.external_domain}"
    consul = "https://consul.${var.prefix}.${var.external_domain}"
  }
  description = "Hashicorp clusters endpoints"
}
output "worker_node_service_account" {
  value       = [aws_iam_role.worker_plane.arn]
  description = "Worker plane ARN"
}

output "PROJECT_PLATFORM_TFVAR" {
  value       = local.tfvars_platform
  description = "Caravan Platform tfvars"
}

output "PROJECT_APPSUPP_TFVAR" {
  value       = local.tfvars_appsupport
  description = "Caravan Application Support tfvars"
}

output "PROJECT_WORKLOAD_TFVAR" {
  value       = local.tfvars_workload
  description = "Caravan Workload tfvars"
}

output "ca_certs" {
  value       = "${abspath(path.module)}/ca_certs.pem"
  description = "Let's Encrypt staging CA certificates"
}

output "csi_volumes" {
  value = var.enable_nomad ? local.volumes_name_to_id : {}
}
