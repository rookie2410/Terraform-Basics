provider "aws" {
    region = "us-east-1"
      
}

resource "aws_instance" "test1" {
    ami = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    subnet_id = "subnet-0e5b207389330ebb1"
    key_name = "aws_login"
}