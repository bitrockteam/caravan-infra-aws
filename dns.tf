data "aws_route53_zone" "main" {
  name         = "${var.external_domain}."
  private_zone = false
}

resource "aws_route53_zone" "hashicorp_zone" {
  name = "${var.prefix}.${var.external_domain}"

  tags = {
    Project = var.prefix
  }
}

resource "aws_route53_record" "hashicorp_zone_ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.prefix}.${var.external_domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.hashicorp_zone.name_servers
}

resource "aws_route53_record" "vault_cname" {
  zone_id = aws_route53_zone.hashicorp_zone.zone_id
  name    = "vault.${var.prefix}.${var.external_domain}"
  type    = "CNAME"
  ttl     = "5"

  records = [aws_lb.hashicorp_alb.dns_name]
}
resource "aws_route53_record" "consul_cname" {
  zone_id = aws_route53_zone.hashicorp_zone.zone_id
  name    = "consul.${var.prefix}.${var.external_domain}"
  type    = "CNAME"
  ttl     = "5"

  records = [aws_lb.hashicorp_alb.dns_name]
}
resource "aws_route53_record" "nomad_cname" {
  zone_id = aws_route53_zone.hashicorp_zone.zone_id
  name    = "nomad.${var.prefix}.${var.external_domain}"
  type    = "CNAME"
  ttl     = "5"

  records = [aws_lb.hashicorp_alb.dns_name]
}

resource "aws_route53_record" "all_cname" {
  zone_id = aws_route53_zone.hashicorp_zone.zone_id
  name    = "*.${var.prefix}.${var.external_domain}"
  type    = "CNAME"
  ttl     = "5"

  records = [aws_lb.hashicorp_alb.dns_name]
}