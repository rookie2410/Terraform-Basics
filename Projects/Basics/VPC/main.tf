resource "aws_vpc" "aws-prod" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "aws-prod-exam"
  }
}

resource "aws_internet_gateway" "aws-prod-gateway" {
    vpc_id = aws_vpc.aws-prod.id
    
    tags = {
        Name = "aws-prod-exam-gateway"
    }
}

locals {
  subnets = {
    "subnet-1" = { cidr_block = "10.0.0.0/20", availability_zone = "us-east-1a", tag_name = "aws-prod-exam-subnet-public1-us-east-1a" }
    "subnet-2" = { cidr_block = "10.0.16.0/20", availability_zone = "us-east-1b", tag_name = "aws-prod-exam-subnet-public2-us-east-1b" }
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

locals {
  private_subnets = {
    "subnet-1" = { cidr_block = "10.0.128.0/20", availability_zone = "us-east-1a", tag_name = "aws-prod-exam-subnet-private1-us-east-1a" }
    "subnet-2" = { cidr_block = "10.0.144.0/20", availability_zone = "us-east-1b", tag_name = "aws-prod-exam-subnet-private2-us-east-1b" }
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




resource "aws_route_table" "aws_route_table_public" {
    vpc_id = aws_vpc.aws-prod.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aws-prod-gateway.id
}

    tags = {
      Name = "aws-prod-exam-route-table_public"
    }
}

resource "aws_route_table_association" "route-table-association-public" {
    for_each = aws_subnet.public_subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.aws_route_table_public.id

}

resource "aws_route_table" "aws_route_table_private" {
    for_each = local.private_subnets
    vpc_id = aws_vpc.aws-prod.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aws-prod-gateway.id
}

    tags = {
      Name = each.value.tag_name
    }
}

resource "aws_route_table_association" "route-table-association-private" {
    for_each = aws_subnet.private_subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.aws_route_table_private[each.key].id

}