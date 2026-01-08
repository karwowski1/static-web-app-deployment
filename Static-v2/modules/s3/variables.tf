variable "s3_name" {
  description = "Name of the S3 bucket"
  default = "s3-static-app-v2"
  type = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type = map(string)
  default = {
    Name        = "Static-app"
    Environment = "Dev"
  }
}