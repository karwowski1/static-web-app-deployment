variable "env" {
  description = "The environment for the CloudWatch setup"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID to monitor"
  type        = string
}

variable "waf_name" {
  description = "The name of the WAF to monitor"
  type        = string
}