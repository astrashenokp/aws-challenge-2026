variable "aws_region" {
  description = "AWS region where all region-specific resources will be created."
  type        = string
}

variable "vpc_name" {
  description = "Name tag value for the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "subnet1_name" {
  description = "Name tag value for the first public subnet."
  type        = string
}

variable "subnet1_cidr" {
  description = "CIDR block for the first public subnet."
  type        = string
}

variable "availability_zone1" {
  description = "Availability Zone for the first public subnet."
  type        = string
}

variable "subnet2_name" {
  description = "Name tag value for the second public subnet."
  type        = string
}

variable "subnet2_cidr" {
  description = "CIDR block for the second public subnet."
  type        = string
}

variable "availability_zone2" {
  description = "Availability Zone for the second public subnet."
  type        = string
}

variable "subnet3_name" {
  description = "Name tag value for the third public subnet."
  type        = string
}

variable "subnet3_cidr" {
  description = "CIDR block for the third public subnet."
  type        = string
}

variable "availability_zone3" {
  description = "Availability Zone for the third public subnet."
  type        = string
}

variable "internet_gateway" {
  description = "Name tag value for the Internet Gateway."
  type        = string
}

variable "routing_table" {
  description = "Name tag value for the public route table."
  type        = string
}
