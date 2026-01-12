output "waf_acl_arn" {
  value = aws_wafv2_web_acl.main.arn

}

output "aws_waf_name" {
  value = aws_wafv2_web_acl.main.name

}