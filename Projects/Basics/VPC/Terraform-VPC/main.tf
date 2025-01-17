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

resource "aws_security_group" "aws-prod-sg" {
    vpc_id = aws_vpc.aws-prod.id
    name = "aws-prod-exam-sg"
    
    tags = {
      Name = "aws-prod-exam-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_http" {
  security_group_id = aws_security_group.aws-prod-sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4 = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_ingress_rule" "inbound_custom" {
  security_group_id = aws_security_group.aws-prod-sg.id
  ip_protocol       = "tcp"
  from_port         = 8000
  to_port           = 8000
  cidr_ipv4 = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_egress_rule" "outbound_all" {
  security_group_id = aws_security_group.aws-prod-sg.id
  ip_protocol       = "-1"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"

}

resource "aws_lb" "aws-prod" {
    name               = "aws-prod-exam-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.aws-prod-sg.id]
    subnets            = [aws_subnet.public_subnets["subnet-1"].id, aws_subnet.public_subnets["subnet-2"].id]
  
}

resource "aws_lb_target_group" "aws-prod" {
    name     = "aws-prod-exam-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.aws-prod.id

    health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
  }
  
}

resource "aws_lb_listener" "aws-prod-lb-listener" {
    load_balancer_arn = aws_lb.aws-prod.arn
    port              = "80"
    protocol          = "HTTP"
  
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.aws-prod.arn
    }
  
}

resource "aws_launch_template" "aws-prod-ec2" {
    name = "aws-prod-exam-ec2"
    image_id = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    key_name = "aws-prod-exam-key"
    network_interfaces {
      security_groups = [aws_security_group.aws-prod-sg.id]
    }
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "aws-prod-exam-ec2"
      }
    }
    
}

resource "aws_autoscaling_group" "aws-prod-ec2-group" {
    launch_template {
        id = aws_launch_template.aws-prod-ec2.id
        version = "$Latest"
    }
    vpc_zone_identifier = [aws_subnet.private_subnets["subnet-1"].id, aws_subnet.private_subnets["subnet-2"].id]
    target_group_arns = [aws_lb_target_group.aws-prod.arn]
    min_size = 1
    max_size = 3
    desired_capacity = 2
    
    tag {
        key = "Name"
        value = "aws-prod-exam-ec2"
        propagate_at_launch = true
    }
}


resource "aws_key_pair" "aws-prod-exam-key" {
    key_name   = "aws-prod-exam-key"
    public_key = file("/mnt/d/Roshan/AWS/AWS/id_rsa.pub")
  
}

resource "aws_instance" "aws-prod-bastion" {
    ami = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    key_name = "aws-prod-exam-key"
    security_groups = [aws_security_group.aws-prod-sg.id]
    subnet_id = aws_subnet.public_subnets["subnet-1"].id
    associate_public_ip_address = true
    tags = {
        Name = "aws-prod-exam-bastion"
    }
  
}

output "bastion_public_ip" {
  value = aws_instance.aws-prod-bastion.public_ip
}

# Outputs
output "alb_dns_name" {
  value = aws_lb.aws-prod.dns_name
  
}