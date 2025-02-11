resource "aws_autoscaling_group" "aws-prod-ec2-group" {
  launch_template {
    id =var.aws_launch_template_id
    version = "$Latest"
  }
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns = [var.target_group_arn]
  min_size = 1
  max_size = 3
  desired_capacity = 2

  tag {
    key = "Name"
    value = "aws-prod-exam-ec2"
    propagate_at_launch = true
  }
  
}