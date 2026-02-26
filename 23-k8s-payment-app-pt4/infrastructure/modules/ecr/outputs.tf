output "api_repository_url" {
  description = "URL of the API repository"
  value       = aws_ecr_repository.api.repository_url
}

output "worker_repository_url" {
  description = "URL of the Worker repository"
  value       = aws_ecr_repository.worker.repository_url
}