aws_region = "eu-west-1"

project_id = "cmtr-4r4d888y"

vpc_name = "cmtr-4r4d888y-vpc"

public_subnet_a_cidr  = "10.0.1.0/24"
private_subnet_a_cidr = "10.0.2.0/24"
public_subnet_b_cidr  = "10.0.3.0/24"
private_subnet_b_cidr = "10.0.4.0/24"

ssh_security_group_name  = "cmtr-4r4d888y-ec2_sg"
http_security_group_name = "cmtr-4r4d888y-http_sg"
lb_security_group_name   = "cmtr-4r4d888y-sglb"

iam_instance_profile = "cmtr-4r4d888y-instance_profile"
key_name             = "cmtr-4r4d888y-keypair"

aws_launch_template_name = "cmtr-4r4d888y-template"
aws_asg_name             = "cmtr-4r4d888y-asg"
load_balancer            = "cmtr-4r4d888y-loadbalancer"
