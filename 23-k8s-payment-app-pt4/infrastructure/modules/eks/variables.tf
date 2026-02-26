variable "project_name" {
  description = "Project name to be used for the cluster name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS nodes"
  type        = list(string)
}