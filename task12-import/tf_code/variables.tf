variable "aws_region" {
  description = "AWS region where resources are managed."
  type        = string
}

variable "policy_name" {
  description = "Name of the existing IAM policy to import."
  type        = string
}
