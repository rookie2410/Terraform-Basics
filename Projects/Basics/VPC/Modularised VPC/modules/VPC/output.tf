output "vpc_id" {
  value = aws_vpc.aws-prod.id  
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id 
}