locals {
  le_staging    = "https://acme-staging-v02.api.letsencrypt.org/directory"
  le_production = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "acme" {
  server_url = var.use_le_staging ? local.le_staging : local.le_production
}

module "terraform_acme_le" {
  depends_on = [
    aws_route53_record.hashicorp_zone_ns
  ]

  source       = "git::ssh://git@github.com/bitrockteam/caravan-acme-le?ref=refs/tags/v0.0.1"
  common_name  = "${var.prefix}.${var.external_domain}"
  dns_provider = "aws"
  private_key  = tls_private_key.cert_private_key.private_key_pem
  aws_region   = var.region
  aws_profile  = var.awsprofile
  aws_zone_id  = aws_route53_zone.hashicorp_zone.id
}

resource "null_resource" "ca_certs" {
  for_each = var.ca_certs
  provisioner "local-exec" {
    command = "curl -o ${each.value.filename} ${each.value.pemurl}"
  }
}

resource "null_resource" "ca_certs_bundle" {
  depends_on = [
    null_resource.ca_certs
  ]
  count = length(var.ca_certs)
  provisioner "local-exec" {
    command = "cat ${join(" ", [for k, v in var.ca_certs : v.filename])} > ca_certs.pem"
  }
}
