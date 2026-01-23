variable "vpc_cidr" {
  description = "CIDR block for the VPC network"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Env name"
  type        = string
}

variable "region" {
  description = "Which region"
  type        = string
}

variable "image_tag" {
  description = "Tag obrazu Dockera"
  type        = string
}