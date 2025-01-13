locals {
  subnets = {
    "subnet-1" = { cidr_block = "10.0.0.0/20", availability_zone = "us-east-1a", tag_name = "aws-prod-exam-subnet-public1-us-east-1a" }
    "subnet-2" = { cidr_block = "10.0.16.0/20", availability_zone = "us-east-1b", tag_name = "aws-prod-exam-subnet-public2-us-east-1b" }
  }
  private_subnets = {
    "subnet-1" = { cidr_block = "10.0.128.0/20", availability_zone = "us-east-1a", tag_name = "aws-prod-exam-subnet-private1-us-east-1a" }
    "subnet-2" = { cidr_block = "10.0.144.0/20", availability_zone = "us-east-1b", tag_name = "aws-prod-exam-subnet-private2-us-east-1b" }
  }
}

resource "aws_subnet" "public_subnets" {
    for_each = local.subnets
    vpc_id = aws_vpc.aws-prod.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = true
  
    tags = {
        Name = each.value.tag_name
    }
}


resource "aws_subnet" "private_subnets" {
    for_each = local.private_subnets
    vpc_id = aws_vpc.aws-prod.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = false
  
    tags = {
        Name = each.value.tag_name
    }
}