resource "aws_iam_policy" "custom_policy" {
  name        = var.policy_name
  path        = data.aws_iam_policy.existing.path
  description = data.aws_iam_policy.existing.description
  policy      = data.aws_iam_policy.existing.policy

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
