resource "aws_wafv2_web_acl" "main" {
  name        = "rate-limit-protection"
  description = "Limit 100 requests/min"
  scope       = "CLOUDFRONT"
  provider    = aws.us-east-1

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CloudFrontWAF"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "RateLimit100"
    priority = 1
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit100"
      sampled_requests_enabled   = true
    }
  }
}