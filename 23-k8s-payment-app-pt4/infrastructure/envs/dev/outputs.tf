output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "api_repository_url" {
  value = module.ecr.api_repository_url
}

output "worker_repository_url" {
  value = module.ecr.worker_repository_url
}

output "new_db_private_ip" {
  description = "Private IP address of the new RDS instance"
  value       = module.ec2.vm_private_ip
}
