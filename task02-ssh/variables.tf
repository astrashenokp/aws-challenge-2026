variable "aws_region" {
  description = "AWS region where all region-specific resources will be created."
  type        = string
}

variable "project_id" {
  description = "Project identifier used to discover existing platform resources and tag created resources."
  type        = string
}

variable "aws_keypair_name" {
  description = "Name of the AWS key pair to create."
  type        = string
}

variable "aws_instance_name" {
  description = "Name tag value for the EC2 instance."
  type        = string
}

variable "aws_security_group_name" {
  description = "Name of the existing security group that allows SSH access."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to use for the SSH test instance."
  type        = string
}

variable "ssh_key" {
  description = "Provides custom public SSH key."
  type        = string
}
