output "sg_id" {
  description = "value of the security group id"
  value       = aws_security_group.aws-prod-sg.id
}

output "bastion_sg_id" {
  description = "value of the bastion security group id"
  value       = aws_security_group.bastion-sg.id
}

output "bastion-profile" {
  description = "value of the bastion instance profile"
  value       = aws_iam_instance_profile.bastion_profile.name
}