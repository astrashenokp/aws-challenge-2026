resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [data.aws_security_group.selected.id]
  associate_public_ip_address = true

  tags = {
    Name      = var.ec2_instance_name
    Terraform = "true"
    Project   = var.project_id
  }
}
