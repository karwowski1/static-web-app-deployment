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

variable "infrastructure_subnet_id" {
  type        = string
  description = "ID of the private subnet where the ACA will be deployed. This subnet should have service endpoints enabled for Azure Container Registry."
}

variable "acr_login_server" {
  type = string

}

variable "image_name" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "acr_username" {
  type = string
}

variable "acr_password" {
  type      = string
  sensitive = true
}

variable "vnet_id" {
  type = string
}
variable "log_analytics_workspace_id" {
  type = string
}
