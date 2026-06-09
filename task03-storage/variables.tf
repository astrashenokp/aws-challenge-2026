variable "aws_region" {
  description = "AWS region where region-specific resources will be created."
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging AWS resources."
  type        = string
}
