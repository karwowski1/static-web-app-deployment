variable "project_name" {
  type = string

}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "public_subnet_id" {
  type = string
}

variable "backend_fqdn" {
  type = string
}

variable "backend_ip" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}
