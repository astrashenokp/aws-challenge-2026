data "aws_caller_identity" "current" {}

locals {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.policy_name}"
}

data "aws_iam_policy" "existing" {
  arn = local.policy_arn
}
