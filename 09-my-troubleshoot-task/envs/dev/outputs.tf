output "alb_url" {
  description = "Application address"
  value       = "http://${module.alb.dns_name}"
}

output "ecr_repo_url" {
  description = "ECR repo address"
  value       = module.ecr.repository_url
}

