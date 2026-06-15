resource "aws_instance" "bastion" {
  ami                         = "ami-0521cb2d60cfbb1a6"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    var.sg_id
  ]
  iam_instance_profile = var.instance_profile_name
  tags = {
    Name = "bastion"
  }
}

