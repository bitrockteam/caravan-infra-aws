resource "aws_ebs_volume" "csi" {
  for_each = var.csi_volumes

  availability_zone = lookup(each.value, "availability_zone", "${var.region}a")
  size              = lookup(each.value, "size", 30)
  type              = lookup(each.value, "type", "gp3")

  tags = merge(
    {
      Name     = each.value
      platform = "nomad"
    },
    lookup(each.value, "tags", {})
  )
}

locals {
  volumes_name_to_id = { for v in aws_ebs_volume.csi : v.tags["Name"] => v.id }
}
