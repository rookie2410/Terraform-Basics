variable "region" {
  description = "The AWS region to deploy to"
  default     = "us-east-2"
}

variable "access_key" {
  description = "This is the access key for aws"
}

variable "secret_key" {
  description = "This is the secret key for aws"
}

variable "bucket_name" {
  description = "This is the name of the bucket"

}

variable "instance_type" {
  description = "This is the type of instance to be created"
  default     = "t2.micro"

}

variable "ami_id" {
  description = "This is the ami id of the instance"
}

variable "subnet_id" {
  description = "This is the subnet id of the instance"
}