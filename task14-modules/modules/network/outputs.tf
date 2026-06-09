output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets."
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.public_3.id
  ]
}
