module "s3_website" {
  source   = "../../modules/s3"
  s3_name  = "s3-static-app-v2"
  tags     = {
    Name        = "Static-app"
    Environment = "Dev"
  }
}

module "cloudfront" {
  source               = "../../modules/cloudfront"
  origin_id            = module.s3_website.bucket_id
  bucket_domain_name   = module.s3_website.bucket_domain_name
  waf_acl_id           = module.waf.waf_acl_arn
  logging_bucket_domain = module.s3_website.logs_bucket_domain_name
  tags = {
    Name        = "Static-app-CF"
    Environment = "Dev"
  }
  
}


module "waf" {
  source = "../../modules/waf"
  providers = {
    aws = aws.us_east_1
  }
  waf_tags = {
    Name        = "Static-app-WAF-Dev"
    Environment = "Dev"
  }
  
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  
  env = "dev"
  cloudfront_distribution_id = module.cloudfront.cloudfront_distribution_id
  waf_name = module.waf.aws_waf_name
}


