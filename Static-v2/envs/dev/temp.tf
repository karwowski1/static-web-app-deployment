resource "aws_s3_bucket" "temp" {
  bucket = "s3_name"
  force_destroy = true
}