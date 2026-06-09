resource "aws_iam_group" "this" {
  name = var.iam_group_name
}

resource "aws_iam_policy" "s3_write" {
  name = var.iam_policy_name

  policy = templatefile("${path.module}/policy.json", {
    bucket_name = var.bucket_name
  })

  tags = {
    Project = var.project_id
  }
}

resource "aws_iam_role" "ec2" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = var.project_id
  }
}

resource "aws_iam_role_policy_attachment" "s3_write" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.s3_write.arn
}

resource "aws_iam_instance_profile" "this" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.ec2.name

  tags = {
    Project = var.project_id
  }
}
