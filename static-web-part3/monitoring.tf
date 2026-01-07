resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "CloudFront-Monitor"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/WAFV2", "BlockedRequests", "WebACL", "rate-limit-protection", "Region", "us-east-1"],
            ["AWS/CloudFront", "Requests", "DistributionId", module.cloudfront_website.distribution_id]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "WAF Blocked vs Total Requests"
        }
      }
    ]
  })
}