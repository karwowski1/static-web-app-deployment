variable "location" {
  description = "Default Region"
  type        = string
  default     = "polandcentral"
}

variable "project_name" {
  description = "Main prefix for all resources (DRY)"
  type        = string
  default     = "staticwebsiteazure"
}

variable "common_tags" {
  description = "Common tags applied to all resources (DRY)"
  type        = map(string)
  default = {
    project = "static-website"
  }
}
