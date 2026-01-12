variable "waf_tags" {
  description = "Tags to apply to the WAF"
  type        = map(string)
  default = {
    Name        = "Static-app-WAF"
    Environment = "Dev"
  }
}