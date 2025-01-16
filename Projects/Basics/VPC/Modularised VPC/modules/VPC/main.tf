#VPC Creation

resource "aws_vpc" "aws-prod" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "aws-prod-exam"
  }
}


#Subnet Creation
resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidr_blocks)
  vpc_id     = aws_vpc.aws-prod.id
  cidr_block = var.subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_names[count.index]
  }
}

#Internet Gateway Creation

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws-prod.id

  tags = {
    Name = "aws-prod-example-gateway"
  }
}

#Route Table Creation

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.aws-prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

  tags = {
    Name = "aws-prod-exam-route-table"
}

}

#Route Table Association

resource "aws_route_table_association" "route_table_association" {
  count = length(var.subnet_cidr_blocks)
  subnet_id = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}
