variable "project_id" {
  description = "Project identifier used for tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets used by the ALB and Auto Scaling Group."
  type        = list(string)
}

variable "ssh_security_group_id" {
  description = "ID of the SSH security group for EC2 instances."
  type        = string
}

variable "public_http_security_group_id" {
  description = "ID of the public HTTP security group for the ALB."
  type        = string
}

variable "private_http_security_group_id" {
  description = "ID of the private HTTP security group for EC2 instances."
  type        = string
}

variable "aws_launch_template_name" {
  description = "Name of the launch template."
  type        = string
}

variable "aws_asg_name" {
  description = "Name of the Auto Scaling Group."
  type        = string
}

variable "load_balancer" {
  description = "Name of the Application Load Balancer."
  type        = string
}
