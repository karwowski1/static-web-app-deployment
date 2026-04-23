output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.app_cluster.alb_dns_name
}
