variable "sg_id" {
    description = "value of the security group id"
    type = string
  
}

variable "ec2_names" {
    description = "The names of the ec2 instances"
    type        = list(string) 
    default = [ "aws-prod-exam-ec2-instance1" , "aws-prod-exam-ec2-instance2" ] 
  
}

variable "subnet_ids" {
    description = "The ids of the subnets"
    type        = list(string) 
}