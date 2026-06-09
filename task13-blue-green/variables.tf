variable "aws_region" {
  description = "AWS region where resources are managed."
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging resources."
  type        = string
}

variable "vpc" {
  description = "Name of the existing VPC."
  type        = string
}

variable "public_subnet1" {
  description = "Name of the first existing public subnet."
  type        = string
}

variable "public_subnet2" {
  description = "Name of the second existing public subnet."
  type        = string
}

variable "ssh_inbound" {
  description = "Name of the existing SSH security group."
  type        = string
}

variable "http_inbound" {
  description = "Name of the existing HTTP security group for EC2 instances."
  type        = string
}

variable "lb_http_inbound" {
  description = "Name of the existing HTTP security group for the load balancer."
  type        = string
}

variable "load_balancer" {
  description = "Name of the Application Load Balancer."
  type        = string
}

variable "blue_target_group_name" {
  description = "Name of the Blue target group."
  type        = string
}

variable "green_target_group_name" {
  description = "Name of the Green target group."
  type        = string
}

variable "blue_asg_name" {
  description = "Name of the Blue Auto Scaling group."
  type        = string
}

variable "green_asg_name" {
  description = "Name of the Green Auto Scaling group."
  type        = string
}

variable "blue_launch_template_name" {
  description = "Name of the Blue launch template."
  type        = string
}

variable "green_launch_template_name" {
  description = "Name of the Green launch template."
  type        = string
}

variable "blue_weight" {
  description = "Traffic weight for the Blue target group."
  type        = number
}

variable "green_weight" {
  description = "Traffic weight for the Green target group."
  type        = number
}
