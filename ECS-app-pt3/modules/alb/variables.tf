variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs for the ALB"
    type        = list(string)
}

variable "project_name" {
  description = "The name of the project to prefix resource names"
  type        = string
}
