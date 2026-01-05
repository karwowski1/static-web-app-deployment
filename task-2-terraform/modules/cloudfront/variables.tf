variable "bucket_regional_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
}

variable "project_name" {
  description = "Project tag name"
  type        = string
  default     = "static-website"
}