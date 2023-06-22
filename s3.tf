resource "aws_s3_bucket" "main" {
  bucket_prefix = "cf-s3-redirection-"
}

resource "aws_s3_bucket_website_configuration" "main" {
  redirect_all_requests_to {
    host_name = "www.${local.naked_domain}"
    protocol  = "https"
  }
  bucket = aws_s3_bucket.main.id
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
