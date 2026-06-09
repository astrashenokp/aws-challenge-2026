output "instance_id" {
  description = "ID of the EC2 instance created with discovered infrastructure values."
  value       = aws_instance.ec2_instance.id
}

output "vpc_id" {
  description = "ID of the discovered VPC."
  value       = data.aws_vpc.selected.id
}

output "public_subnet_id" {
  description = "ID of the discovered public subnet."
  value       = data.aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the discovered security group."
  value       = data.aws_security_group.selected.id
}
