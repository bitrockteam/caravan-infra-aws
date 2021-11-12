data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "vault_kms_unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = [aws_kms_key.vault.arn]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

data "aws_iam_policy_document" "vault_client" {
  statement {
    sid    = "VaultClient"
    effect = "Allow"

    actions = ["ec2:DescribeInstances"]

    resources = ["*"]
  }
}


// aws_iam_role
resource "aws_iam_role" "control_plane" {
  name               = "${var.prefix}-control-plane-${random_pet.env.id}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role" "worker_plane" {
  name               = "${var.prefix}-worker-plane-${random_pet.env.id}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// aws_iam_instance_profile
resource "aws_iam_instance_profile" "control_plane" {
  name = "${var.prefix}-control-plane-${random_pet.env.id}"
  role = aws_iam_role.control_plane.name
}
resource "aws_iam_instance_profile" "worker_plane" {
  name = "${var.prefix}-worker-plane-${random_pet.env.id}"
  role = aws_iam_role.worker_plane.name
}

// aws_iam_role_policy
resource "aws_iam_role_policy" "vault_kms_unseal" {
  name   = "${var.prefix}-vault-kms-unseal-${random_pet.env.id}"
  role   = aws_iam_role.control_plane.id
  policy = data.aws_iam_policy_document.vault_kms_unseal.json
}
resource "aws_iam_role_policy" "vault_aws_auth" {
  name = "${var.prefix}-control-plane-policy"
  role = aws_iam_role.control_plane.name

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "iam:GetInstanceProfile",
          "iam:GetUser",
          "iam:GetRole"
        ],
        "Resource": "*"
      },
      {
        "Sid": "ManageOwnAccessKeys",
        "Effect": "Allow",
        "Action": [
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:GetAccessKeyLastUsed",
          "iam:GetUser",
          "iam:ListAccessKeys",
          "iam:UpdateAccessKey"
        ],
        "Resource": "arn:aws:iam::*:user/$${aws:username}"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "vault_client" {
  name   = "${var.prefix}-vault-client-${random_pet.env.id}"
  role   = aws_iam_role.worker_plane.name
  policy = data.aws_iam_policy_document.vault_client.json
}

resource "aws_iam_role_policy" "csi" {
  count  = var.enable_nomad ? 1 : 0
  name   = "${var.prefix}-ebs-csi-client"
  role   = aws_iam_role.worker_plane.id
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumesModifications",
        "ec2:DetachVolume",
        "ec2:ModifyVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "docker_pull" {
  policy = <<-EOT
{
  "Version": "2008-10-17",
  "Statement": [
      {
          "Sid": "AllowPull",
          "Effect": "Allow",
          "Action": [
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:GetAuthorizationToken"
          ],
          "Resource": "*"
      }
  ]
}
EOT
  role   = aws_iam_role.worker_plane.id
}
