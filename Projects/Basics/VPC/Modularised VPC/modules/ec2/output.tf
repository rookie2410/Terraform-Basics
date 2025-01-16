output "aws_instance_ids" {
  value = aws_instance.aws-prod-instance[*].id
  
}