locals {
  common_tags = {
    Project = "epam-tf-lab"
    ID      = var.project_id
  }
}

resource "aws_key_pair" "this" {
  key_name   = var.aws_keypair_name
  public_key = var.ssh_key

  tags = merge(local.common_tags, {
    Name = var.aws_keypair_name
  })
}
