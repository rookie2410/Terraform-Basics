
output "website_url" {
  value = aws_s3_bucket.s3.website_endpoint
}