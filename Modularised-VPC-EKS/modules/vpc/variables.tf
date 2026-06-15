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
  default     = ["vpc-demo-subnet-public1-us-east-1a", "vpc-demo-subnet-public2-us-east-1b"]
}

variable "private_subnet_names" {
  description = "The names of the subnets"
  type        = list(string)
  default     = ["vpc-demo-subnet-private1-us-east-1a", "vpc-demo-subnet-private2-us-east-1b"]
}

variable "private_rt_name" {
  description = "The name of the private route table"
  type        = list(string)
  default     = ["private-rt-1", "private-rt-2"]

}

variable "elastic_ip" {
  description = "Elastic IP for NAT Gateway"
  type        = list(string)
  default     = ["nat-eip-1", "nat-eip-2"]
}


variable "nat_gw_name" {
  description = "Name of the NAT Gateway"
  type        = list(string)
  default     = ["nat-gw-1", "nat-gw-2"]
}
