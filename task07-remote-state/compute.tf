data "aws_ami" "amazon_linux" {
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

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.base_infra.outputs.security_group_id]
  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}
