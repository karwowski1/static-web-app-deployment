variable "project_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cdn_profile_id" {
  type = string
}

variable "log_storage_account_id" {
  type = string
}
