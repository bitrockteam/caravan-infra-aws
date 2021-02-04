resource "aws_ebs_volume" "jenkins" {
  count             = var.aws_csi ? 1 : 0
  availability_zone = "${var.region}a"
  size              = 30
  type              = "gp3"
  tags = {
    platform = "nomad"
    job      = "jenkins-master"
  }
}
