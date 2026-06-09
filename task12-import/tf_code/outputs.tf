output "policy_arn" {
  description = "ARN of the imported IAM policy."
  value       = aws_iam_policy.custom_policy.arn
}

output "policy_name" {
  description = "Name of the imported IAM policy."
  value       = aws_iam_policy.custom_policy.name
}
