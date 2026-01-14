resource "aws_s3_bucket" "temp" {
  bucket        = "s3-name"
  force_destroy = true
}