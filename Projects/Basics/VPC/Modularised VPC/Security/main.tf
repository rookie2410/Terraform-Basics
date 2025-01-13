
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