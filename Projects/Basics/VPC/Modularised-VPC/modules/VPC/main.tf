#VPC Creation

resource "aws_vpc" "aws-prod" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "aws-prod-exam"
  }
}


#Public Subnet Creation
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id     = aws_vpc.aws-prod.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_names[count.index]
  }
}


#Private Subnet Creation
resource "aws_subnet" "private_subnets" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.aws-prod.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_names[count.index]
  }

}


#Internet Gateway Creation

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws-prod.id

  tags = {
    Name = "aws-prod-example-gateway"
  }
}

#Public Route Table Creation

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.aws-prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

  tags = {
    Name = "aws-prod-exam-route-table-public"
}

}

#Public Route Table Association

resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnet_cidr_blocks)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#Private Route Table Creation

resource "aws_route_table" "private_route_table" {
  count = length(var.private_rt_name)
  vpc_id = aws_vpc.aws-prod.id

  tags = {
    Name = var.private_rt_name[count.index]
}

}

#Private Route Table Association

resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnet_cidr_blocks)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
