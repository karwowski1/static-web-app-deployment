# output "cluster_endpoint" {
#   value = module.eks.cluster_endpoint
# }

# output "cluster_name" {
#   value = module.eks.cluster_name
# }

# output "ecr_repo_api" {
#   value = aws_ecr_repository.api.repository_url
# }

# output "ecr_repo_worker" {
#   value = aws_ecr_repository.worker.repository_url
# }

output "new_db_private_ip" {
  description = "Prywatny adres IP nowej bazy na EC2"
  value       = module.ec2.vm_private_ip 
}