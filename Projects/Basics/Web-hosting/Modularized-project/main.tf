provider "aws" {
  region = var.region

}

resource "aws_s3_bucket" "s3" {
    bucket = "my-project-test-bucket-hosting-module"

    tags = {
        Name        = "My bucket basic project hosting"
        Environment = "test"
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
      object_ownership = var.ownership_control
    }
  
}

resource "aws_s3_bucket_acl" "s3-acl-proj-block" {
    depends_on = [aws_s3_bucket_ownership_controls.s3-owner-proj-block]

    bucket = aws_s3_bucket.s3.id
    acl    = var.bucket_Acl
  
}


resource "aws_s3_object" "s3-object-proj-block" {
    for_each        = fileset("site/", "*")
    bucket          = aws_s3_bucket.s3.id
    key             = each.value
    source          = "site/${each.value}"
    content_type    = var.object_configurations
    etag            = filemd5("site/${each.value}")
    acl             = var.bucket_Acl
    
}

resource "aws_s3_bucket_website_configuration" "s3-config-proj-block" {
    bucket = aws_s3_bucket.s3.id

    index_document {
        suffix = var.index_document
    }
  
}