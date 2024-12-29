variable "region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"

}

variable "ownership_control" {
  description = "The ownership control for the bucket"
  default     = "Objectowner"
}

variable "bucket_Acl" {
  description = "The ACL for the bucket"
  default     = "private"
}

variable "object_configurations" {
  description = "The configurations for the objects"
  default     = "text/html"
}

variable "index_document" {
  description = "The index document for the bucket"
  default     = "index.html"
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