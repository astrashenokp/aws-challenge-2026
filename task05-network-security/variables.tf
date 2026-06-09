variable "aws_region" {
  description = "AWS region where region-specific resources will be created."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging AWS resources."
  type        = string
}

variable "allowed_ip_range" {
  description = "List of CIDR IP ranges allowed to access public infrastructure."
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the existing VPC."
  type        = string
}

variable "public_instance_id" {
  description = "ID of the existing public EC2 instance."
  type        = string
}

variable "private_instance_id" {
  description = "ID of the existing private EC2 instance."
  type        = string
}

variable "ssh_security_group_name" {
  description = "Name of the SSH security group to create."
  type        = string
}

variable "public_http_security_group_name" {
  description = "Name of the public HTTP security group to create."
  type        = string
}

variable "private_http_security_group_name" {
  description = "Name of the private HTTP security group to create."
  type        = string
}
