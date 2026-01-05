resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

 
  tags = {
    project = var.project_name
  }
}


resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  source       = "${path.root}/index.html" 
  content_type = "text/html"
}