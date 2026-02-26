resource "aws_ecr_repository" "api" {
  name         = "payment-api-pt3"
  force_delete = true
}

resource "aws_ecr_repository" "worker" {
  name         = "payment-worker-pt3"
  force_delete = true
}