variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string  
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)

}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)

}

variable "public_subnet_names" {
  description = "The names of the subnets"
  type        = list(string) 
  default = [ "aws-prod-exam-subnet-public1-us-east-1a" , "aws-prod-exam-subnet-public2-us-east-1b" ] 
}

variable "private_subnet_names" {
  description = "The names of the subnets"
  type        = list(string) 
  default = [ "aws-prod-exam-subnet-private1-us-east-1a" , "aws-prod-exam-subnet-private2-us-east-1b" ] 
}

variable "private_rt_name" {
  description = "The name of the private route table"
  type        = list(string)
  default     = ["private-rt-1a", "private-rt-1b"]
  
}

