variable "aws_region" {
  description = "AWS region where region-specific resources will be created."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging AWS resources."
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC."
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block of the existing public subnet A."
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR block of the existing private subnet A."
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block of the existing public subnet B."
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "CIDR block of the existing private subnet B."
  type        = string
}

variable "ssh_security_group_name" {
  description = "Name of the existing security group that allows SSH access to EC2 instances."
  type        = string
}

variable "http_security_group_name" {
  description = "Name of the existing security group that allows HTTP access to EC2 instances."
  type        = string
}

variable "lb_security_group_name" {
  description = "Name of the existing security group that allows HTTP access to the load balancer."
  type        = string
}

variable "iam_instance_profile" {
  description = "Name of the existing IAM instance profile for EC2 instances."
  type        = string
}

variable "key_name" {
  description = "Name of the existing EC2 key pair for SSH access."
  type        = string
}

variable "aws_launch_template_name" {
  description = "Name of the AWS Launch Template to create."
  type        = string
}

variable "aws_asg_name" {
  description = "Name of the Auto Scaling Group to create."
  type        = string
}

variable "load_balancer" {
  description = "Name of the Application Load Balancer to create."
  type        = string
}
