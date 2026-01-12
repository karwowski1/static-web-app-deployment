variable "github_repo" {
  description = "GitHub repository for GitHub Actions"
  type        = string
  default     = "karwowski1/static-web-app-deployment"
}

variable "state_bucket_name" {
  description = "S3 Bucket name for Terraform state storage"
  type        = string
  default     = "s3-static-app-v2"
}