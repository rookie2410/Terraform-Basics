output "aws_lb_id" {
  value = aws_lb.aws-prod-ex-lb.id  
}

output "aws_lb_target_group_id" {
  value = aws_lb_target_group.aws-prod-tg.id      
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.aws-prod-tg.arn      
  
}
output "aws_lb_listener_arn" {
  value = aws_lb_listener.aws-prod-lb-listener.arn   
}

output "aws_lb_listener_id" {
  value = aws_lb_listener.aws-prod-lb-listener.id  
}