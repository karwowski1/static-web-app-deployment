provider "aws" {
  region = "eu-central-1"
}

# API repo
resource "aws_ecr_repository" "payment_api" {
  name                 = "payment-api-prod"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Worker repo
resource "aws_ecr_repository" "payment_worker" {
  name                 = "payment-worker-prod"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

# outputs
output "api_repo_url" {
  value = aws_ecr_repository.payment_api.repository_url
}

output "worker_repo_url" {
  value = aws_ecr_repository.payment_worker.repository_url
}