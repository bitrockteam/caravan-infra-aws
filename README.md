# hashicorp-terraform-infra-aws

## Prerequisites

- AWS Credentials file at `~/.aws/credentials` like
```
[default]
aws_access_key_id=AKIAJPZXVYEXAMPLE
aws_secret_access_key=4k6ZilhMPdshU6/kuwEExAmPlE
```
- Create `aws.tfvars` file with
```hcl
region                  = "eu-central-1"       # region of choice
shared_credentials_file = "~/.aws/credentials" # AWS credentials file path
awsprofile              = "default"            # AWS credentials profile name
prefix                  = "hashicorp"          # prefix for resource names
personal_ip_list        = ["0.0.0.0/0"]        # whitelist ips for remote connection
use_le_staging          = true                 # whether to use LE staging or production endpoint 
external_domain         = "my-domain.io"       # an existing route53 public zone. A new zone named ${prefix}.${external_domain} will be created in route53 containing all needed entries
```
- Create `backend.tf` file with the chosen Terraform state backend, such as
```hcl
terraform {
  backend "s3" {
    bucket         = "my-bucket"                  # existing S3 bucket
    key            = "path/to/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "my-dynamodb-table"          # existing dynamo db table
  }
}
```

## Running

```shell
terraform apply --var-file aws.tfvars
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.1 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| local | n/a |
| null | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_csi | provision csi disks | `bool` | `true` | no |
| awsprofile | AWS user profile | `string` | n/a | yes |
| ca\_certs | Fake certificates from staging Let's Encrypt | <pre>map(object({<br>    filename = string<br>    pemurl   = string<br>  }))</pre> | <pre>{<br>  "fakeleintermediatex1": {<br>    "filename": "fakeleintermediatex1.pem",<br>    "pemurl": "https://letsencrypt.org/certs/fakeleintermediatex1.pem"<br>  },<br>  "fakelerootx1": {<br>    "filename": "fakelerootx1.pem",<br>    "pemurl": "https://letsencrypt.org/certs/fakelerootx1.pem"<br>  }<br>}</pre> | no |
| control\_plane\_instance\_count | Control plane instances number | `number` | `3` | no |
| control\_plane\_machine\_type | Control plane instance machine type | `string` | `"t2.micro"` | no |
| dc\_name | Hashicorp cluster name | `string` | `"aws-dc"` | no |
| enable\_monitoring | Enable monitoring | `bool` | `true` | no |
| external\_domain | Domain used for endpoints and certs | `string` | `""` | no |
| monitoring\_machine\_type | Monitoring instance machine type | `string` | `"t2.large"` | no |
| personal\_ip\_list | IP address list for SSH connection to the VMs | `list(string)` | n/a | yes |
| prefix | The prefix of the objects' names | `string` | n/a | yes |
| region | AWS region to use | `string` | n/a | yes |
| shared\_credentials\_file | AWS credential file path | `string` | n/a | yes |
| tfstate\_bucket\_name | S3 Bucket where Terraform state is stored | `string` | `""` | no |
| tfstate\_region | AWS Region where Terraform state resources are | `string` | `""` | no |
| tfstate\_table\_name | DynamoDB Table where Terraform state lock is acquired | `string` | `""` | no |
| use\_le\_staging | Use staging Let's Encrypt endpoint | `bool` | `true` | no |
| volume\_size | Volume size of workers disk | `number` | `100` | no |
| vpc\_cidr | VPC cidr | `string` | `"10.0.0.0/16"` | no |
| vpc\_private\_subnets | VCP private subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| vpc\_public\_subnets | VCP public subnets | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |
| worker\_plane\_machine\_type | Working plane instance machine type | `string` | `"t3.small"` | no |
| workers\_group\_size | Worker plane instances number | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| PROJECT\_APPSUPP\_TFVAR | Caravan Application Support tfvars |
| PROJECT\_PLATFORM\_TFVAR | Caravan Platform tfvars |
| PROJECT\_WORKLOAD\_TFVAR | Caravan Workload tfvars |
| ca\_certs | Let's Encrypt staging CA certificates |
| cluster\_public\_ips | Control plane public IP addresses |
| control\_plane\_iam\_role\_arns | Control plane iam role list |
| control\_plane\_role\_name | Control plane role name |
| hashicorp\_endpoints | Hashicorp clusters endpoints |
| jenkins\_master\_vol\_id | EBS Volume ID for Jenkins Master |
| load\_balancer\_ip\_address | Load Balancer IP address |
| region | AWS region |
| vpc\_id | VPC ID |
| worker\_node\_service\_account | Worker plane ARN |
| worker\_plane\_iam\_role\_arns | Worker plane iam role list |
| worker\_plane\_role\_name | Worker plane role name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
