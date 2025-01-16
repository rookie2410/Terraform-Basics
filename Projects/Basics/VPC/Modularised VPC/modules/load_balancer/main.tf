#ALB
resource "aws_lb" "aws-prod-ex-lb" {
    name = "aws-app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.sg_id]
    subnets = var.subnets
  
}

#Listerner
resource "aws_lb_listener" "aws-prod-lb-listener" {

    load_balancer_arn = aws_lb.aws-prod-ex-lb.arn
    port = 80
    protocol = "HTTP"
  
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.aws-prod-tg.arn
      
    }
  
}

#Target Group
resource "aws_lb_target_group" "aws-prod-tg" {
    name = "aws-prod-exam-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
  
    health_check {
      interval = 30
      path = "/"
      timeout = 5
    }
  
}

#Target Group Attachment
resource "aws_lb_target_group_attachment" "aws-prod-tg-attachment" {
    count = length(var.instances)
    target_group_arn = aws_lb_target_group.aws-prod-tg.arn
    target_id = var.instances[count.index]
    port = 80
  
}