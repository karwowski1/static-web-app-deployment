resource "aws_ecr_repository" "api" {
  name         = "payment-api"
  force_delete = true
}

resource "aws_ecr_repository" "worker" {
  name         = "payment-worker"
  force_delete = true
}