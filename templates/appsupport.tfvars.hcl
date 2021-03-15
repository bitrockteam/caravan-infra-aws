
vault_endpoint             = "https://vault.${prefix}.${external_domain}"
consul_endpoint            = "https://consul.${prefix}.${external_domain}"
nomad_endpoint             = "https://nomad.${prefix}.${external_domain}"
domain                     = "${prefix}.${external_domain}"
artifacts_source_prefix    = ""
container_registry         = ""
services_domain            = "service.consul"
dc_names                   = ["${dc_name}"]
cloud                      = "aws"
jenkins_volume_external_id = "${jenkins_volume_id}"

%{ if use_le_staging ~}
vault_skip_tls_verify = true
consul_insecure_https = true
ca_cert_file          = "../caravan-infra-aws/ca_certs.pem"
%{ else ~}
vault_skip_tls_verify = false
consul_insecure_https = false
%{ endif ~}
