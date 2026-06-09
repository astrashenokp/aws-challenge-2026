aws_region = "eu-west-1"

project_id = "cmtr-4r4d888y"

vpc            = "cmtr-4r4d888y-vpc"
public_subnet1 = "cmtr-4r4d888y-public-subnet1"
public_subnet2 = "cmtr-4r4d888y-public-subnet2"

ssh_inbound     = "cmtr-4r4d888y-sg-ssh"
http_inbound    = "cmtr-4r4d888y-sg-http"
lb_http_inbound = "cmtr-4r4d888y-sg-lb"

load_balancer = "cmtr-4r4d888y-lb"

blue_target_group_name  = "cmtr-4r4d888y-blue-tg"
green_target_group_name = "cmtr-4r4d888y-green-tg"

blue_asg_name  = "cmtr-4r4d888y-blue-asg"
green_asg_name = "cmtr-4r4d888y-green-asg"

blue_launch_template_name  = "cmtr-4r4d888y-blue-template"
green_launch_template_name = "cmtr-4r4d888y-green-template"

blue_weight  = 100
green_weight = 0
