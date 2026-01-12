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


resource "aws_s3_bucket" "logs" {
  bucket        = "${var.bucket_name}-logs"
  force_destroy = true
}


resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logs" {
  depends_on = [aws_s3_bucket_ownership_controls.logs]
  bucket     = aws_s3_bucket.logs.id
  acl        = "log-delivery-write"
}


resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "expire-30-days"
    status = "Enabled"
    filter {}
    expiration {
      days = 30
    }
  }
}