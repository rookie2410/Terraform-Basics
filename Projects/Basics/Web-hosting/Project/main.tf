provider "aws" {

    region = "us-east-1"
  
}

resource "aws_s3_bucket" "s3" {
  bucket = "my-project-test-bucket-hosting"

  tags = {
    Name        = "My bucket basic project hosting"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-public-proj-block" {
  bucket = aws_s3_bucket.s3.id 

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3-owner-proj-block" {
  bucket = aws_s3_bucket.s3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
    # object_ownership = "BucketOwnerEnforced"
    }
}

resource "aws_s3_bucket_acl" "s3-acl-proj-block" {
depends_on = [aws_s3_bucket_ownership_controls.s3-owner-proj-block]

  bucket = aws_s3_bucket.s3.id
  acl    = "public-read"
}

resource "aws_s3_object" "s3-object-html-proj-block" {
 

   for_each        = fileset("site/", "*")
    bucket          = aws_s3_bucket.s3.id
    key             = each.value
    source          = "site/${each.value}"
    content_type    = "text/html"
    etag            = filemd5("site/${each.value}")
    acl             = "public-read"

}


resource "aws_s3_bucket_website_configuration" "s3-config-proj-block" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }

}

output "website_url" {
  value = aws_s3_bucket.s3.website_endpoint
}