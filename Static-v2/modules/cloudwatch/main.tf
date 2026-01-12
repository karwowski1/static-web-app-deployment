resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "Static-App-Dashboard-${var.env}"

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
            [
              "AWS/CloudFront",
              "Requests",
              "DistributionId",
              var.cloudfront_distribution_id
            ]
          ]
          view    = "timeSeries"
          stacked = false
          period  = 300
          region  = "us-east-1"
          title   = "CloudFront Requests"
        }
      },
      {
        type   = "metric" 
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/WAFV2",
              "BlockedRequests",
              "WebACL",
              var.waf_name,
              "Rule",
              "ALL",
              "Region",
              "us-east-1",
              { "color": "#d62728" }
            ]
          ]

          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"
          title   = "WAF Blocked Requests"
          period  = 300
        }
      }
    ]
  })
}