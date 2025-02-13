resource "aws_key_pair" "server_test_key" {
  key_name   = "server_key_name"
  # public_key = file("~/.ssh/terraform.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzeH1WBl48kpL/b9/TbsqAtlVN7rRL6dRyBdQ0NMFgGi4g3gl5QzJ/vtZmBlTBHND9endltFkYczrcRL1X53hgkb+qqvGWzn9LSeobto1V98nerJEc+cXKqBzHEj6juzYcCZmDzr0pTbfNUJAhIcAI5vTBzj2BTEXGhW+oJlb5oqhJW2QRllhpb0gHCuVy4iI7CS2PLwtNrTdyasZJ4GcWUk+zcP0VpJx3Vr1IkTZ3oxDdnD4+2kyBfUW3C/oilcIywQ/eyS5J59jL6ZvzLefPsIvcWiDQje8Zsd2UM5TGMXCgbUvtmB2r2exgc+aMU+BE0AH//x8zfFjKFZS6YS/P1C5nWHNmPF3ISGeOpq/E0GE9coB5AHOUfbQrM7Y825b7vsAXboOHoLU3twmtNVV+fVUFMT1i4dw8+L23UuBBVCtUfj4Ew301kiRL1vChRz7TWUtYcaDhjHCTUhiLYxpIzwakjLXU0XHCCQlIOow4MtKAreqjU26FsjFjOdUSCfs= dev@Oblivion"

}

resource "aws_launch_template" "aws-prod-ec2" {
  name = "aws-prod-exam-ec2"
  image_id = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name        = aws_key_pair.server_test_key.key_name
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "aws-prod-exam-ec2"
    }
  } 
}

resource "aws_instance" "public_bastion" {
  ami = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  security_groups = [ var.sg_id]
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name        = aws_key_pair.server_test_key.key_name
  tags = {
    Name = "aws-prod-exam-bastion"
  }
  
}

#To be worked on (learning included)
resource "null_resource" "file_provisioner" {
 
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    host     = aws_instance.public_bastion.public_ip
  }

  provisioner "file" {
    source = "./index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "file" {
    source = "~/.ssh/terraform"
    destination = "/home/terraform"
  }

  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "cd /home/ubuntu/",
      "sleep 20",
      "python3 -m http.server 8000",
    ]
  }
  
}

