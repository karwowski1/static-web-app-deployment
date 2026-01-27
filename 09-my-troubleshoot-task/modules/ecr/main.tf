# -----------------
# ECR
# -----------------
resource "aws_ecr_repository" "app" {
  name                 = "${var.name}-ecr-repo"
  image_tag_mutability = "MUTABLE"

  force_delete = true

  tags = {
    Name = "${var.name}-app"
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 50 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 50
      }
      action = { type = "expire" }
    }]
  })
}
