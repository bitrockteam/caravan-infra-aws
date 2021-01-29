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
//output "pd_ssd_jenkins_master_id" {
//  value = var.gcp_csi ? google_compute_region_disk.jenkins_master[0].id : null
//}
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
  value = templatefile("${path.module}/templates/platform-tfvar.tmpl",
    {
      prefix                  = var.prefix,
      external_domain         = var.external_domain,
      region                  = var.region,
      dc_name                 = var.dc_name
      shared_credentials_file = var.shared_credentials_file
      profile                 = var.awsprofile
  })
}

//output "PROJECT_APPSUPP_TFVAR" {
//  value = templatefile("${path.module}/templates/appsupp-tfvar.tmpl",
//    {
//      project_id      = var.project_id,
//      prefix          = var.prefix,
//      external_domain = var.external_domain,
//      region          = var.region
//      dc_name         = var.dc_name
//  })
//}
//
//output "PROJECT_WORKLOAD_TFVAR" {
//  value = templatefile("${path.module}/templates/workload-tfvar.tmpl",
//    {
//      project_id      = var.project_id,
//      prefix          = var.prefix,
//      external_domain = var.external_domain,
//      region          = var.region
//      dc_name         = var.dc_name
//  })
//}

output "ca_certs" {
  value = "${abspath(path.module)}/ca_certs.pem"
}
