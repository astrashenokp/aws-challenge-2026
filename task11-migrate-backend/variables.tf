variable "aws_region" {
  description = "AWS region where resources are managed."
  type        = string
}

variable "policy_name" {
  description = "Name of the IAM policy managed by Terraform."
  type        = string
}

variable "policy_path" {
  description = "Path of the IAM policy managed by Terraform."
  type        = string
}

variable "policy_description" {
  description = "Description of the IAM policy managed by Terraform."
  type        = string
}

variable "policy_document" {
  description = "JSON policy document of the IAM policy managed by Terraform."
  type        = string
}

variable "policy_tags" {
  description = "Tags of the IAM policy managed by Terraform."
  type        = map(string)
}
