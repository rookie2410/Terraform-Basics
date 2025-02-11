variable "aws_lb_listener_arn" {
  description = "The ARN of the listener"
  type = string
  
}

variable "private_subnet_ids" {
  description = "The ids of the subnets"
  type        = list(string) 
  
}

variable "aws_launch_template_id" {
  description = "The ID of the launch template"
  type = string
  
}

variable "target_group_arn" {
  description = "value of the target group arn"
    type = string
}