output "load_balancer_dns_name" {
  description = "DNS name of the created Application Load Balancer."
  value       = aws_lb.app.dns_name
}

output "launch_template_id" {
  description = "ID of the created Launch Template."
  value       = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  description = "Name of the created Auto Scaling Group."
  value       = aws_autoscaling_group.app.name
}

output "target_group_arn" {
  description = "ARN of the created target group."
  value       = aws_lb_target_group.app.arn
}
