resource "random_pet" "env" {
  length    = 2
  separator = "_"
}

resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  enable_key_rotation     = true
  deletion_window_in_days = 10

  tags = {
    Name    = "vault-kms-unseal-${random_pet.env.id}"
    Project = var.prefix
  }
}
