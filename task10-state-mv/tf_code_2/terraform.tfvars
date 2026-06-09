aws_region = "eu-west-1"

policy_name        = "resource-move-demo-policy"
policy_path        = "/"
policy_description = "Custom role with limited permissions"

policy_document = <<EOT
{"Statement":[{"Action":["ec2:*","s3:*"],"Effect":"Allow","Resource":"*"}],"Version":"2012-10-17"}
EOT

policy_tags = {}
