
module "s3_website" {
  source      = "./modules/s3"
  bucket_name = var.root_bucket_name
  project_name = var.root_project_name
}


module "cloudfront_website" {
  source                      = "./modules/cloudfront"
  bucket_regional_domain_name = module.s3_website.bucket_regional_domain_name
  project_name                = var.root_project_name
}


resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = module.s3_website.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = "${module.s3_website.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront_website.distribution_arn
          }
        }
      }
    ]
  })
}