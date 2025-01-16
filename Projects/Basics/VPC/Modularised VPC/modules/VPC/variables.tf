variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string  
}

variable "subnet_cidr_blocks" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)
}

variable "subnet_names" {
  description = "The names of the subnets"
  type        = list(string) 
  default = [ "aws-prod-exam-subnet-public1" , "aws-prod-exam-subnet-public2" ] 
}