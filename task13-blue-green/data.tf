data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc]
  }
}

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet1]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet2]
  }
}

data "aws_security_group" "ssh" {
  filter {
    name   = "group-name"
    values = [var.ssh_inbound]
  }

  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "http" {
  filter {
    name   = "group-name"
    values = [var.http_inbound]
  }

  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "lb_http" {
  filter {
    name   = "group-name"
    values = [var.lb_http_inbound]
  }

  vpc_id = data.aws_vpc.selected.id
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
