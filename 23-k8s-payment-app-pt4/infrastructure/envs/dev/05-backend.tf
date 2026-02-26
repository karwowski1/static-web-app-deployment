resource "aws_s3_bucket" "terraform_state" {
  bucket = "finpay-tf-state-k8s-payment-app-pt3"

  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "TF State Store"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}