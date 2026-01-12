resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.bucket_domain_name
    origin_id                = var.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  enabled = true

  logging_config {
    include_cookies = false
    bucket          = var.logging_bucket_domain
    prefix          = "logs/"
  }

  web_acl_id = var.waf_acl_id

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/error.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 500
    response_code         = 200
    response_page_path    = "/error.html"
    error_caching_min_ttl = 10
  }

  tags = var.tags
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "s3-oac-static-app"
  description                       = "OAC for S3 static website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
