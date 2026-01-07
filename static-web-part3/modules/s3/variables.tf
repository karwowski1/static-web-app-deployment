variable "bucket_name" {
  description = "tfstate-part2-lock"
  type        = string
}

variable "project_name" {
  description = "Project tag name"
  type        = string
  default     = "static-website"
}