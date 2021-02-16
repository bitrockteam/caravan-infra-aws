output "control_plane_role_name" {
  value = local.control_plane_role_name
}
output "worker_plane_role_name" {
  value = local.worker_plane_role_name
}
output "control_plane_iam_role_arns" {
  value = [aws_iam_role.control_plane.arn]
}
output "worker_plane_iam_role_arns" {
  value = [aws_iam_role.worker_plane.arn]
}
output "region" {
  value = var.region
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_public_ips" {
  value = { for n in aws_instance.hashicorp_cluster : n.tags["Name"] => n.public_ip }
}
output "load_balancer_ip_address" {
  value = aws_lb.hashicorp_alb.dns_name
}
output "jenkins_master_vol_id" {
  value = var.aws_csi ? aws_ebs_volume.jenkins[0].id : null
}
output "hashicorp_endpoints" {
  value = {
    vault  = "https://vault.${var.prefix}.${var.external_domain}"
    consul = "https://consul.${var.prefix}.${var.external_domain}"
    nomad  = "https://nomad.${var.prefix}.${var.external_domain}"
  }
}
output "worker_node_service_account" {
  value = [aws_iam_role.worker_plane.arn]
}

output "PROJECT_PLATFORM_TFVAR" {
  value = local.tfvars_platform
}

output "PROJECT_APPSUPP_TFVAR" {
  value = local.tfvars_appsupport
}

output "PROJECT_WORKLOAD_TFVAR" {
  value = local.tfvars_workload
}

output "ca_certs" {
  value = "${abspath(path.module)}/ca_certs.pem"
}
