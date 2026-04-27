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
  type = string
  description = "ID konta magazynu przeznaczonego na logi z Front Doora"
}
