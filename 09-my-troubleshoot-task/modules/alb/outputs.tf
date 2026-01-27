output "security_group_id" {
  description = "The security group ID for the ALB"
  value       = aws_security_group.alb.id
  
}

output "target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.web.arn
  
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}