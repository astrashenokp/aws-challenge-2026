variable "aws_region" {
  description = "AWS region where existing resources are located."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging AWS resources."
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC to discover."
  type        = string
}

variable "public_subnet_name" {
  description = "Name tag of the existing public subnet to discover."
  type        = string
}

variable "security_group_name" {
  description = "Name tag of the existing security group to discover."
  type        = string
}

variable "ec2_instance_name" {
  description = "Name tag value for the EC2 instance to create."
  type        = string
}
