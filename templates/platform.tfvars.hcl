
vault_endpoint  = "https://vault.${prefix}.${external_domain}"
consul_endpoint = "https://consul.${prefix}.${external_domain}"
consul_internal_address = "${alb_dns}:8500"
%{ if enable_nomad ~}
nomad_endpoint = "https://nomad.${prefix}.${external_domain}"
%{ else }
nomad_endpoint = ""
enable_nomad = false
%{ endif ~}

%{ if use_le_staging ~}
vault_skip_tls_verify = true
consul_insecure_https = true
ca_cert_file          = "../caravan-infra-aws/ca_certs.pem"
%{ else ~}
vault_skip_tls_verify = false
consul_insecure_https = false
%{ endif ~}

auth_providers = ["aws"]

aws_region                  = "${region}"
aws_shared_credentials_file = "${shared_credentials_file}"
aws_profile                 = "${profile}"

bootstrap_state_backend_provider   = "aws"
bootstrap_state_bucket_name_prefix = "${prefix}-terraform-state"
bootstrap_state_object_name_prefix = "infraboot/terraform/state"
s3_bootstrap_region                = "${region}"
