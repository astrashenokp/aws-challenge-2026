variable "aws_region" {
  description = "AWS region where region-specific resources will be created."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging AWS resources."
  type        = string
}

variable "bucket_name" {
  description = "Name of the existing S3 bucket used in the IAM policy."
  type        = string
}

variable "iam_group_name" {
  description = "Name of the IAM group to create."
  type        = string
}

variable "iam_policy_name" {
  description = "Name of the custom IAM policy to create."
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role to create for EC2."
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to create."
  type        = string
}
