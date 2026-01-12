resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_name
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.website_bucket.id # POPRAWIONE

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.website_bucket.id # POPRAWIONE

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket = "${var.s3_name}-logs"
  tags   = var.tags
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket_ownership" {
  bucket = aws_s3_bucket.logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "logs_bucket_public_access_block" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "logs_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.logs_bucket_ownership,
    aws_s3_bucket_public_access_block.logs_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_bucket_lifecycle" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id # POPRAWIONE (było .this.id)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        # Poniżej kluczowa poprawka: odwołujemy się do zasobu lokalnie, a nie przez module.
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*" 
      }
    ]
  })
}