module "s3_website" {
  source   = "../../modules/s3"
  s3_name  = "s3-static-app-v2"
  tags     = {
    Name        = "Static-app"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = module.s3_website.bucket_id
  key    = "index.html"
  source = "../../src/index.html"
  content_type = "text/html"
  
}

module "cloudfront" {
  source               = "../../modules/cloudfront"
  origin_id            = module.s3_website.bucket_id
  bucket_domain_name   = module.s3_website.bucket_domain_name
  tags = {
    Name        = "Static-app-CF"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_website.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action = "s3:GetObject"
        Resource = "${module.s3_website.bucket_arn}/*"
      }
    ]
  })
}