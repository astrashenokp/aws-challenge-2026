locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }

  subnet_ids = [
    data.aws_subnet.public_1.id,
    data.aws_subnet.public_2.id
  ]

  instance_security_group_ids = [
    data.aws_security_group.ssh.id,
    data.aws_security_group.http.id
  ]
}

resource "aws_lb" "app" {
  name               = var.load_balancer
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.lb_http.id]
  subnets            = local.subnet_ids

  tags = merge(local.common_tags, {
    Name = var.load_balancer
  })
}

resource "aws_lb_target_group" "blue" {
  name                 = var.blue_target_group_name
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.selected.id
  target_type          = "instance"
  deregistration_delay = 5

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

  tags = merge(local.common_tags, {
    Name        = var.blue_target_group_name
    Environment = "blue"
  })
}

resource "aws_lb_target_group" "green" {
  name                 = var.green_target_group_name
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.selected.id
  target_type          = "instance"
  deregistration_delay = 5

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

  tags = merge(local.common_tags, {
    Name        = var.green_target_group_name
    Environment = "green"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }

  tags = local.common_tags
}

resource "aws_launch_template" "blue" {
  name          = var.blue_launch_template_name
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = local.instance_security_group_ids
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

dnf install -y httpd curl

TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")
PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4 || echo "unknown")

cat > /var/www/html/index.html <<HTML
<!doctype html>
<html>
  <body>
    <h1>Blue Environment</h1>
    <p>Environment: Blue Environment</p>
    <p>Instance ID: $INSTANCE_ID</p>
    <p>Private IP: $PRIVATE_IP</p>
  </body>
</html>
HTML

systemctl enable --now httpd
EOF
  )

  tags = merge(local.common_tags, {
    Name        = var.blue_launch_template_name
    Environment = "blue"
  })

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name        = var.blue_launch_template_name
      Environment = "blue"
    })
  }
}

resource "aws_launch_template" "green" {
  name          = var.green_launch_template_name
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = local.instance_security_group_ids
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

dnf install -y httpd curl

TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")
PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4 || echo "unknown")

cat > /var/www/html/index.html <<HTML
<!doctype html>
<html>
  <body>
    <h1>Green Environment</h1>
    <p>Environment: Green Environment</p>
    <p>Instance ID: $INSTANCE_ID</p>
    <p>Private IP: $PRIVATE_IP</p>
  </body>
</html>
HTML

systemctl enable --now httpd
EOF
  )

  tags = merge(local.common_tags, {
    Name        = var.green_launch_template_name
    Environment = "green"
  })

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name        = var.green_launch_template_name
      Environment = "green"
    })
  }
}

resource "aws_autoscaling_group" "blue" {
  name                      = var.blue_asg_name
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  vpc_zone_identifier       = local.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 30
  force_delete              = true

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.blue_asg_name
    propagate_at_launch = true
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

  tag {
    key                 = "Environment"
    value               = "blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name                      = var.green_asg_name
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  vpc_zone_identifier       = local.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 30
  force_delete              = true

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.green_asg_name
    propagate_at_launch = true
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

  tag {
    key                 = "Environment"
    value               = "green"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "blue" {
  autoscaling_group_name = aws_autoscaling_group.blue.name
  lb_target_group_arn    = aws_lb_target_group.blue.arn
}

resource "aws_autoscaling_attachment" "green" {
  autoscaling_group_name = aws_autoscaling_group.green.name
  lb_target_group_arn    = aws_lb_target_group.green.arn
}
