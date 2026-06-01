variable "project_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "public_subnet_prefixes" {
  type = list(string)
}

variable "private_subnet_prefixes" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

