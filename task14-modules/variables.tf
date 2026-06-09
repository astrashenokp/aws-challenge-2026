variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging resources."
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC."
  type        = string
}

variable "subnet1_name" {
  description = "Name of the first public subnet."
  type        = string
}

variable "subnet1_cidr" {
  description = "CIDR block of the first public subnet."
  type        = string
}

variable "availability_zone1" {
  description = "Availability Zone of the first public subnet."
  type        = string
}

variable "subnet2_name" {
  description = "Name of the second public subnet."
  type        = string
}

variable "subnet2_cidr" {
  description = "CIDR block of the second public subnet."
  type        = string
}

variable "availability_zone2" {
  description = "Availability Zone of the second public subnet."
  type        = string
}

variable "subnet3_name" {
  description = "Name of the third public subnet."
  type        = string
}

variable "subnet3_cidr" {
  description = "CIDR block of the third public subnet."
  type        = string
}

variable "availability_zone3" {
  description = "Availability Zone of the third public subnet."
  type        = string
}

variable "internet_gateway" {
  description = "Name of the Internet Gateway."
  type        = string
}

variable "routing_table" {
  description = "Name of the public route table."
  type        = string
}

variable "allowed_ip_range" {
  description = "List of CIDR IP ranges allowed to access public resources."
  type        = list(string)
}

variable "ssh_security_group_name" {
  description = "Name of the SSH security group."
  type        = string
}

variable "public_http_security_group_name" {
  description = "Name of the public HTTP security group."
  type        = string
}

variable "private_http_security_group_name" {
  description = "Name of the private HTTP security group."
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
