variable "secret_key" {
  description = "value of the secret"
}

variable "access_key" {
  description = "value of the access key"
}

variable "region" {
  description = "The AWS region to deploy to"
  default     = "us-east-2"

}
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string  
}

variable "subnet_cidr_blocks" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)
  
}