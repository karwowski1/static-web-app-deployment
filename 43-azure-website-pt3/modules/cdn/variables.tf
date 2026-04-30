variable "project_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_host_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "log_storage_account_id" {
  type        = string
  description = "Storage account ID where CDN logs will be stored. Ensure this storage account is in the same region as the CDN profile for optimal performance."
}

