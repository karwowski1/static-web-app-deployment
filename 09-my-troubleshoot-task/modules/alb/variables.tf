variable "name" {
  type        = string
  description = "Prefix for resource names"
  default     = "troubleshoot-ecs"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the existing VPC"  
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in the existing VPC"
}