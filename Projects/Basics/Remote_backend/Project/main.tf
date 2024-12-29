provider "aws" {
    region     = var.region
    secret_key = var.secret_key
    access_key = var.access_key
  
}

resource "aws_instance" "roshan" {
    instance_type = var.instance_type
  
}