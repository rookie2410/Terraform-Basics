resource "aws_security_group" "aws-prod-sg" {
  name   = "aws-prod-exam-sg"
  description = "Allow HTTP and SSH inbound traffic on port 80 and 22"
  vpc_id = var.vpc_id


  ingress {
    description = "Allow HTTP inbound traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow SSH inbound traffic"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "aws-prod-exam-sg"
  }
  
}