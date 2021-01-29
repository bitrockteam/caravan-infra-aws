module "terraform_acme_le" {
  source       = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-acme-le?ref=master"
  common_name  = "${var.prefix}.${var.external_domain}"
  dns_provider = "route53"
  le_endpoint  = var.le_endpoint
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
