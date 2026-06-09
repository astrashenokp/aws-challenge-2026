locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }

  target_group_name = substr("${var.project_id}-tg", 0, 32)
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "cidr-block"
    values = [var.public_subnet_a_cidr]
  }
}

data "aws_subnet" "public_b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "cidr-block"
    values = [var.public_subnet_b_cidr]
  }
}

data "aws_security_group" "ssh" {
  filter {
    name   = "group-name"
    values = [var.ssh_security_group_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_security_group" "http" {
  filter {
    name   = "group-name"
    values = [var.http_security_group_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_security_group" "lb_http" {
  filter {
    name   = "group-name"
    values = [var.lb_security_group_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
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
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  network_interfaces {
    device_index                = 0
    delete_on_termination       = true
    associate_public_ip_address = true
    security_groups             = [data.aws_security_group.ssh.id, data.aws_security_group.http.id]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

dnf install -y httpd jq curl

cat > /etc/httpd/conf.d/no-keepalive.conf <<CONF
KeepAlive Off
MaxKeepAliveRequests 1
CONF

TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat > /var/www/html/index.html <<HTML
<!doctype html>
<html>
  <head>
    <title>Terraform Load Balanced Application</title>
  </head>
  <body>
    <h1>Hello from Terraform</h1>
    <p>Instance ID: $INSTANCE_ID</p>
    <p>Private IP: $PRIVATE_IP</p>
  </body>
</html>
HTML

systemctl enable --now httpd

nohup dnf update -y >/var/log/background-dnf-update.log 2>&1 &
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
  security_groups    = [data.aws_security_group.lb_http.id]
  subnets            = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]

  tags = local.common_tags
}

resource "aws_lb_target_group" "app" {
  name                          = local.target_group_name
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = data.aws_vpc.main.id
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

  stickiness {
    type    = "lb_cookie"
    enabled = false
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
  min_size                  = 1
  max_size                  = 2
  force_delete              = true
  health_check_type         = "ELB"
  health_check_grace_period = 30
  wait_for_capacity_timeout = "7m"
  vpc_zone_identifier       = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]

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

resource "time_sleep" "wait_for_targets" {
  create_duration = "90s"

  depends_on = [
    aws_autoscaling_attachment.app
  ]
}
