variable "root_bucket_name" {
  type        = string
  description = "Nazwa bucketa dla strony (musi byc unikalna!)"
}

variable "root_project_name" {
  type        = string
  default     = "static-website-terraform"
}