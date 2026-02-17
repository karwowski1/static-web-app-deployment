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

resource "aws_ecr_lifecycle_policy" "cleanup_policy_api" {
  repository = aws_ecr_repository.payment_api.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection    = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "cleanup_policy_worker" {
  repository = aws_ecr_repository.payment_worker.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection    = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}

# outputs
output "api_repo_url" {
  value = aws_ecr_repository.payment_api.repository_url
}

output "worker_repo_url" {
  value = aws_ecr_repository.payment_worker.repository_url
}