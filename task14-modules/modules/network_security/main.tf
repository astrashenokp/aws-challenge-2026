locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}

resource "aws_security_group" "ssh" {
  name        = var.ssh_security_group_name
  description = "Allow SSH from allowed IP ranges."
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = var.ssh_security_group_name
  })
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  description       = "Allow SSH from allowed IP ranges."
  security_group_id = aws_security_group.ssh.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
}

resource "aws_security_group_rule" "ssh_egress" {
  type              = "egress"
  description       = "Allow all outbound traffic."
  security_group_id = aws_security_group.ssh.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "public_http" {
  name        = var.public_http_security_group_name
  description = "Allow HTTP from allowed IP ranges."
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = var.public_http_security_group_name
  })
}

resource "aws_security_group_rule" "public_http_ingress" {
  type              = "ingress"
  description       = "Allow HTTP from allowed IP ranges."
  security_group_id = aws_security_group.public_http.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
}

resource "aws_security_group_rule" "public_http_egress" {
  type              = "egress"
  description       = "Allow all outbound traffic."
  security_group_id = aws_security_group.public_http.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "private_http" {
  name        = var.private_http_security_group_name
  description = "Allow HTTP only from the public HTTP security group."
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = var.private_http_security_group_name
  })
}

resource "aws_security_group_rule" "private_http_ingress" {
  type                     = "ingress"
  description              = "Allow HTTP from public HTTP security group."
  security_group_id        = aws_security_group.private_http.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group_rule" "private_http_egress" {
  type              = "egress"
  description       = "Allow all outbound traffic."
  security_group_id = aws_security_group.private_http.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
