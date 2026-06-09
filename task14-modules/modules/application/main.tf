locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }

  target_group_name = substr("${var.project_id}-tg", 0, 32)
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

resource "aws_launch_template" "app" {
  name          = var.aws_launch_template_name
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  network_interfaces {
    device_index                = 0
    delete_on_termination       = true
    associate_public_ip_address = true
    security_groups             = [var.ssh_security_group_id, var.private_http_security_group_id]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

dnf install -y httpd curl

TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat > /var/www/html/index.html <<HTML
<!doctype html>
<html>
  <body>
    <h1>Hello from Terraform module application</h1>
    <p>Instance ID: $INSTANCE_ID</p>
    <p>Private IP: $PRIVATE_IP</p>
  </body>
</html>
HTML

systemctl enable --now httpd
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.common_tags
  }

  tags = local.common_tags
}

resource "aws_lb" "app" {
  name               = var.load_balancer
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_http_security_group_id]
  subnets            = var.public_subnet_ids

  tags = local.common_tags
}

resource "aws_lb_target_group" "app" {
  name                          = local.target_group_name
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  target_type                   = "instance"
  deregistration_delay          = 5
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = local.common_tags
}

resource "aws_autoscaling_group" "app" {
  name                      = var.aws_asg_name
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 2
  force_delete              = true
  health_check_type         = "ELB"
  health_check_grace_period = 30
  wait_for_capacity_timeout = "5m"
  vpc_zone_identifier       = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_id
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [
      load_balancers,
      target_group_arns
    ]
  }
}

resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name = aws_autoscaling_group.app.name
  lb_target_group_arn    = aws_lb_target_group.app.arn

  depends_on = [
    aws_lb_listener.http
  ]
}
