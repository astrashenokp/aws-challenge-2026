aws_region = "eu-west-1"

project_id = "cmtr-4r4d888y"

vpc_id              = "vpc-00e27439cab453aba"
public_instance_id  = "i-01ec6e12c06f61cef"
private_instance_id = "i-032f0f81ac2e83315"

ssh_security_group_name          = "cmtr-4r4d888y-ssh-sg"
public_http_security_group_name  = "cmtr-4r4d888y-public-http-sg"
private_http_security_group_name = "cmtr-4r4d888y-private-http-sg"

allowed_ip_range = [
  "18.153.146.156/32",
  "194.44.142.6/32"
]
