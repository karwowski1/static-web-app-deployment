resource "aws_wafv2_web_acl" "main" {
  name        = "rate-limit-protection"
  description = "Limit 100 requests/min"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
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
      metric_name                = "CloudFrontWAFRule"
      sampled_requests_enabled   = true
    }
  }

  tags = var.waf_tags
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "RateLimit100"
    sampled_requests_enabled   = true
  }
}