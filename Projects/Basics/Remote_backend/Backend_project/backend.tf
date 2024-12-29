terraform {
  backend "s3" {
    bucket = "my-bucket-remote-project-hosting"
    region = "us-east-1"
    key = "remote_backend/terraform.tfstate"
  }
}