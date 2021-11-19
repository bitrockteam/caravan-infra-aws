# Caravan Infra AWS

![Caravan 2021 AWS](https://lucid.app/publicSegments/view/82496ccf-b453-48c6-81df-230784870538/image.png)

## Prerequisites

- AWS Credentials file at `~/.aws/credentials` like
```
[default]
aws_access_key_id=AKIAJPZXVYEXAMPLE
aws_secret_access_key=4k6ZilhMPdshU6/kuwEExAmPlE
```

## Prepare environment

You need an AWS bucket (and a DynamoDB table) for terraform state, so run the script `project-setup.sh` passing as arguments:

1. Prefix name to give to resources (look at terraform inputs)
2. AWS region
3. AWS profile

```bash
./project-setup.sh <NAME> <REGION> <PROFILE>
```

## Running

Edit the generate aws.tfvars and then run:

```shell
terraform init -reconfigure -upgrade
terraform apply --var-file aws.tfvars
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.15.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.51.0 |
| <a name="provider_dns"></a> [dns](#provider\_dns) | 3.2.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_caravan-bootstrap"></a> [caravan-bootstrap](#module\_caravan-bootstrap) | git::https://github.com/bitrockteam/caravan-bootstrap | refs/tags/v0.2.12 |
| <a name="module_cloud_init_control_plane"></a> [cloud\_init\_control\_plane](#module\_cloud\_init\_control\_plane) | git::https://github.com/bitrockteam/caravan-cloudinit | refs/tags/v0.1.13 |
| <a name="module_cloud_init_worker_plane"></a> [cloud\_init\_worker\_plane](#module\_cloud\_init\_worker\_plane) | git::https://github.com/bitrockteam/caravan-cloudinit | refs/tags/v0.1.9 |
| <a name="module_terraform_acme_le"></a> [terraform\_acme\_le](#module\_terraform\_acme\_le) | git::https://github.com/bitrockteam/caravan-acme-le | refs/tags/v0.0.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_autoscaling_group.bastion-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.hashicorp_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ebs_volume.consul_cluster_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.nomad_cluster_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.vault_cluster_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.worker_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.worker_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.docker_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.vault_aws_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.vault_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.vault_kms_unseal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.hashicorp_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.hashicorp_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_key.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_configuration.bastion-service-host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_launch_template.hashicorp_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.hashicorp_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.hashicorp_nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.bastion-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.http_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.http_8500](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.nomad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.bastion-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.nomad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.nomad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.all_cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.consul_cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.hashicorp_zone_ns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.nomad_cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.vault_cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.hashicorp_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_cluster_basics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal_consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal_nomad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_volume_attachment.consul_cluster_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_volume_attachment.nomad_cluster_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_volume_attachment.vault_cluster_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [local_file.backend_tf_appsupport](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.backend_tf_platform](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tfvars_appsupport](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tfvars_platform](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ca_certs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.ca_certs_bundle](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.env](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [tls_private_key.cert_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.centos7](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.debian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vault_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vault_kms_unseal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [dns_a_record_set.alb](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/a_record_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_awsprofile"></a> [awsprofile](#input\_awsprofile) | AWS user profile | `string` | n/a | yes |
| <a name="input_personal_ip_list"></a> [personal\_ip\_list](#input\_personal\_ip\_list) | IP address list for SSH connection to the VMs | `list(string)` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix of the objects' names | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to use | `string` | n/a | yes |
| <a name="input_shared_credentials_file"></a> [shared\_credentials\_file](#input\_shared\_credentials\_file) | AWS credential file path | `string` | n/a | yes |
| <a name="input_ami_filter_name"></a> [ami\_filter\_name](#input\_ami\_filter\_name) | Regexp to find AMI to use built with caravan-baking | `string` | `"*caravan-centos-image-os-*"` | no |
| <a name="input_ca_certs"></a> [ca\_certs](#input\_ca\_certs) | Fake certificates from staging Let's Encrypt | <pre>map(object({<br>    filename = string<br>    pemurl   = string<br>  }))</pre> | <pre>{<br>  "stg-int-r3": {<br>    "filename": "letsencrypt-stg-int-r3.pem",<br>    "pemurl": "https://letsencrypt.org/certs/staging/letsencrypt-stg-int-r3.pem"<br>  },<br>  "stg-root-x1": {<br>    "filename": "letsencrypt-stg-root-x1.pem",<br>    "pemurl": "https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem"<br>  }<br>}</pre> | no |
| <a name="input_consul_license_file"></a> [consul\_license\_file](#input\_consul\_license\_file) | Path to Consul Enterprise license | `string` | `null` | no |
| <a name="input_control_plane_instance_count"></a> [control\_plane\_instance\_count](#input\_control\_plane\_instance\_count) | Control plane instances number | `number` | `3` | no |
| <a name="input_control_plane_machine_type"></a> [control\_plane\_machine\_type](#input\_control\_plane\_machine\_type) | Control plane instance machine type | `string` | `"t3.micro"` | no |
| <a name="input_csi_volumes"></a> [csi\_volumes](#input\_csi\_volumes) | Example:<br>{<br>  "jenkins" : {<br>    "availability\_zone" : "eu-west-1a"<br>    "size" : "30"<br>    "type" : "gp3"<br>    "tags" : { "application": "jenkins\_master" }<br>  }<br>} | `map(map(string))` | `{}` | no |
| <a name="input_dc_name"></a> [dc\_name](#input\_dc\_name) | Hashicorp cluster name | `string` | `"aws-dc"` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable monitoring | `bool` | `true` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain used for endpoints and certs | `string` | `""` | no |
| <a name="input_monitoring_machine_type"></a> [monitoring\_machine\_type](#input\_monitoring\_machine\_type) | Monitoring instance machine type | `string` | `"t3.xlarge"` | no |
| <a name="input_nomad_license_file"></a> [nomad\_license\_file](#input\_nomad\_license\_file) | Path to Nomad Enterprise license | `string` | `null` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | n/a | `map(number)` | <pre>{<br>  "http": 80,<br>  "https": 443<br>}</pre> | no |
| <a name="input_tfstate_bucket_name"></a> [tfstate\_bucket\_name](#input\_tfstate\_bucket\_name) | S3 Bucket where Terraform state is stored | `string` | `""` | no |
| <a name="input_tfstate_region"></a> [tfstate\_region](#input\_tfstate\_region) | AWS Region where Terraform state resources are | `string` | `""` | no |
| <a name="input_tfstate_table_name"></a> [tfstate\_table\_name](#input\_tfstate\_table\_name) | DynamoDB Table where Terraform state lock is acquired | `string` | `""` | no |
| <a name="input_use_le_staging"></a> [use\_le\_staging](#input\_use\_le\_staging) | Use staging Let's Encrypt endpoint | `bool` | `true` | no |
| <a name="input_vault_license_file"></a> [vault\_license\_file](#input\_vault\_license\_file) | Path to Vault Enterprise license | `string` | `null` | no |
| <a name="input_volume_data_size"></a> [volume\_data\_size](#input\_volume\_data\_size) | Volume size of control plan data disk | `number` | `20` | no |
| <a name="input_volume_root_size"></a> [volume\_root\_size](#input\_volume\_root\_size) | Volume size of control plan root disk | `number` | `20` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size of workers disk | `number` | `100` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Volume type of disks | `string` | `"gp3"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidr | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | VCP private subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | VCP public subnets | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |
| <a name="input_worker_plane_machine_type"></a> [worker\_plane\_machine\_type](#input\_worker\_plane\_machine\_type) | Working plane instance machine type | `string` | `"t3.large"` | no |
| <a name="input_workers_group_size"></a> [workers\_group\_size](#input\_workers\_group\_size) | Worker plane instances number | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_PROJECT_APPSUPP_TFVAR"></a> [PROJECT\_APPSUPP\_TFVAR](#output\_PROJECT\_APPSUPP\_TFVAR) | Caravan Application Support tfvars |
| <a name="output_PROJECT_PLATFORM_TFVAR"></a> [PROJECT\_PLATFORM\_TFVAR](#output\_PROJECT\_PLATFORM\_TFVAR) | Caravan Platform tfvars |
| <a name="output_PROJECT_WORKLOAD_TFVAR"></a> [PROJECT\_WORKLOAD\_TFVAR](#output\_PROJECT\_WORKLOAD\_TFVAR) | Caravan Workload tfvars |
| <a name="output_ca_certs"></a> [ca\_certs](#output\_ca\_certs) | Let's Encrypt staging CA certificates |
| <a name="output_cluster_public_ips"></a> [cluster\_public\_ips](#output\_cluster\_public\_ips) | Control plane public IP addresses |
| <a name="output_control_plane_iam_role_arns"></a> [control\_plane\_iam\_role\_arns](#output\_control\_plane\_iam\_role\_arns) | Control plane iam role list |
| <a name="output_control_plane_role_name"></a> [control\_plane\_role\_name](#output\_control\_plane\_role\_name) | Control plane role name |
| <a name="output_csi_volumes"></a> [csi\_volumes](#output\_csi\_volumes) | n/a |
| <a name="output_hashicorp_endpoints"></a> [hashicorp\_endpoints](#output\_hashicorp\_endpoints) | Hashicorp clusters endpoints |
| <a name="output_load_balancer_ip_address"></a> [load\_balancer\_ip\_address](#output\_load\_balancer\_ip\_address) | Load Balancer IP address |
| <a name="output_region"></a> [region](#output\_region) | AWS region |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_worker_node_service_account"></a> [worker\_node\_service\_account](#output\_worker\_node\_service\_account) | Worker plane ARN |
| <a name="output_worker_plane_iam_role_arns"></a> [worker\_plane\_iam\_role\_arns](#output\_worker\_plane\_iam\_role\_arns) | Worker plane iam role list |
| <a name="output_worker_plane_role_name"></a> [worker\_plane\_role\_name](#output\_worker\_plane\_role\_name) | Worker plane role name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Cleaning up

After `terraform destroy -var-file=aws.tfvars`, for removing bucket and dynamodb table, run the `project-cleanup.sh` script:

```bash
./project-cleanup.sh <NAME> <REGION> <PROFILE>
```
