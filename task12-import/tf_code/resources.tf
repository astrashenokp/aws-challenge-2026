resource "aws_iam_policy" "custom_policy" {
  name = var.policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      description,
      path,
      policy,
      tags,
      tags_all
    ]
  }
}
