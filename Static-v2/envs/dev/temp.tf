resource "aws_s3_bucket" "temp" {
  bucket        = "s3-name-skibidi-bakecik"
  force_destroy = true
}