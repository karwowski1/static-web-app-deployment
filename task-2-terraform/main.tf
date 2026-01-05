module "s3_website" {
  source       = "./modules/s3"
  bucket_name  = var.root_bucket_name
  project_name = var.root_project_name
}


module "cloudfront_website" {
  source                      = "./modules/cloudfront"
  bucket_regional_domain_name = module.s3_website.bucket_regional_domain_name
  project_name                = var.root_project_name
  waf_id                      = aws_wafv2_web_acl.main.arn
  logs_bucket_domain_name     = module.s3_website.logs_bucket_domain_name
}


resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = module.s3_website.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${module.s3_website.bucket_arn}/*"
        Condition = {
          StringEquals = { "AWS:SourceArn" = module.cloudfront_website.distribution_arn }
        }
      }
    ]
  })
}


resource "aws_s3_object" "index" {
  bucket       = module.s3_website.bucket_id
  key          = "index.html"
  source       = "${path.root}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.root}/index.html")
}


resource "aws_s3_object" "error_page" {
  bucket       = module.s3_website.bucket_id
  key          = "404.html"
  source       = "${path.root}/404.html"
  content_type = "text/html"
  etag         = filemd5("${path.root}/404.html")
}