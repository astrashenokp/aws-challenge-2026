variable "aws_region" {
  description = "AWS region where region-specific resources will be created."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging AWS resources."
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket name that stores the remote Terraform state."
  type        = string
}

variable "state_key" {
  description = "S3 object key path to the remote Terraform state file."
  type        = string
}
