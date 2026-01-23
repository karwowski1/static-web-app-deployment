variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "github_repo" {
  description = "Github repo name"
  type        = string
}