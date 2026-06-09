aws_region = "eu-west-1"

project_id = "cmtr-4r4d888y"

vpc_name = "cmtr-4r4d888y-vpc"
vpc_cidr = "10.10.0.0/16"

subnet1_name       = "cmtr-4r4d888y-subnet-public-a"
subnet1_cidr       = "10.10.1.0/24"
availability_zone1 = "eu-west-1a"

subnet2_name       = "cmtr-4r4d888y-subnet-public-b"
subnet2_cidr       = "10.10.3.0/24"
availability_zone2 = "eu-west-1b"

subnet3_name       = "cmtr-4r4d888y-subnet-public-c"
subnet3_cidr       = "10.10.5.0/24"
availability_zone3 = "eu-west-1c"

internet_gateway = "cmtr-4r4d888y-igw"
routing_table    = "cmtr-4r4d888y-rt"

allowed_ip_range = [
  "18.153.146.156/32",
  "31.148.23.140/32"
]

ssh_security_group_name          = "cmtr-4r4d888y-ssh-sg"
public_http_security_group_name  = "cmtr-4r4d888y-public-http-sg"
private_http_security_group_name = "cmtr-4r4d888y-private-http-sg"

aws_launch_template_name = "cmtr-4r4d888y-template"
aws_asg_name             = "cmtr-4r4d888y-asg"
load_balancer            = "cmtr-4r4d888y-lb"
