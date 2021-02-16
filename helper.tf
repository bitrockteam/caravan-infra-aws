locals {
  tfvars_platform = templatefile("${path.module}/templates/platform.tfvars.hcl", {
    prefix                  = var.prefix,
    external_domain         = var.external_domain,
    region                  = var.region,
    dc_name                 = var.dc_name
    shared_credentials_file = var.shared_credentials_file
    profile                 = var.awsprofile
    use_le_staging          = var.use_le_staging
  })
  backend_tf_platform = templatefile("${path.module}/templates/backend.hcl", {
    key         = "platform"
    bucket_name = var.tfstate_bucket_name
    region      = var.tfstate_region
    table_name  = var.tfstate_table_name
  })

  tfvars_appsupport = templatefile("${path.module}/templates/appsupport.tfvars.hcl", {
    prefix            = var.prefix,
    external_domain   = var.external_domain,
    region            = var.region
    dc_name           = var.dc_name
    use_le_staging    = var.use_le_staging
    jenkins_volume_id = var.aws_csi ? aws_ebs_volume.jenkins[0].id : ""
  })
  backend_tf_appsupport = templatefile("${path.module}/templates/backend.hcl", {
    key         = "appsupport"
    bucket_name = var.tfstate_bucket_name
    region      = var.tfstate_region
    table_name  = var.tfstate_table_name
  })

  tfvars_workload = templatefile("${path.module}/templates/workload.tfvars.hcl", {
    prefix          = var.prefix,
    external_domain = var.external_domain,
    region          = var.region
    dc_name         = var.dc_name
    use_le_staging  = var.use_le_staging
  })
  backend_tf_workload = templatefile("${path.module}/templates/backend.hcl", {
    key         = "workload"
    bucket_name = var.tfstate_bucket_name
    region      = var.tfstate_region
    table_name  = var.tfstate_table_name
  })
}

resource "local_file" "tfvars_platform" {
  filename = "${path.module}/../caravan-platform/${var.prefix}-aws.tfvars"
  content  = local.tfvars_platform
}
resource "local_file" "backend_tf_platform" {
  filename = "${path.module}/../caravan-platform/${var.prefix}-aws-backend.tf.bak"
  content  = local.backend_tf_platform
}

resource "local_file" "tfvars_appsupport" {
  filename = "${path.module}/../caravan-application-support/${var.prefix}-aws.tfvars"
  content  = local.tfvars_appsupport
}
resource "local_file" "backend_tf_appsupport" {
  filename = "${path.module}/../caravan-application-support/${var.prefix}-aws-backend.tf.bak"
  content  = local.backend_tf_appsupport
}

resource "local_file" "tfvars_workload" {
  filename = "${path.module}/../caravan-workload/${var.prefix}-aws.tfvars"
  content  = local.tfvars_workload
}
resource "local_file" "backend_tf_workload" {
  filename = "${path.module}/../caravan-workload/${var.prefix}-aws-backend.tf.bak"
  content  = local.backend_tf_workload
}
