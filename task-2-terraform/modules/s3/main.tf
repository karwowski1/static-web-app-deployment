resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  # Wymaganie best practices: Tagging
  tags = {
    project = var.project_name
  }
}

# Wymaganie: BlockPublicAcls = true
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Automatyczne wgranie pliku index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  source       = "${path.root}/index.html" # Ścieżka do pliku na Twoim dysku (zakładam, że jest w task-2-terraform/ lub wyżej)
  content_type = "text/html"
}