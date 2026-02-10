variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the bastion will be deployed"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the bastion will be deployed (should be Private)"
}

variable "region" {
  type        = string
  description = "AWS Region"
}