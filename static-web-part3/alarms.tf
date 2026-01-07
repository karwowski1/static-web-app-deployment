resource "aws_sns_topic" "alerts" {
  name = "cloudfront-security-alerts"
  provider = aws.us-east-1
}

resource "aws_sns_topic_subscription" "email_target" {
    topic_arn = aws_sns_topic.alerts.arn
    protocol = "email"
    endpoint = "aws-acc@wp.pl"
    provider = aws.us-east-1
}

resource "aws_cloudwatch_metric_alarm" "waf_block_alarm" {
    alarm_name = "WAF-High-Blocked_Requests"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    metric_name = "BlockedRequests"
    namespace = "AWS/WAFV2"
    period = 300
    statistic = "Sum"
    threshold = 10
    alarm_description = "Alarm when WAF blocks > 10 requests in 5 minutes"
    actions_enabled = true
    alarm_actions = [aws_sns_topic.alerts.arn]      #sends info to SNS
    ok_actions = [aws_sns_topic.alerts.arn]        #sends info to SNS when its ok
    dimensions = {
        WebACL = "rate-limit-protection"
        Region = "us-east-1"                        #This region bc WAF is in USA
        Rule = "ALL"
    }
    provider = aws.us-east-1
}

#CloudWatch checks every 5min (300s) if the number of blocked requests is higher than 10