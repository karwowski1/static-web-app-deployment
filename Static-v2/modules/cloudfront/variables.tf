variable "origin_id" {
    description = "The origin ID for the CloudFront distribution"
    type        = string
    default     = "s3-origin"
}

variable "bucket_domain_name" {
    description = "The domain name of the S3 bucket"
    type        = string
}

variable "tags" {
  description = "Tags to apply to the CloudFront distribution"
  type = map(string)
  default = {
    Name        = "Static-app-CF"
    Environment = "Dev"
  }
}

variable "waf_acl_id" {
  description = "The ARN of the WAF ACL to associate with the CloudFront distribution"
  type        = string
  default     = ""
  
}