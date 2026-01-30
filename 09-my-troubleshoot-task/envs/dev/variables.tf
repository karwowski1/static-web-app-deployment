variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "name" {
  type        = string
  description = "Prefix for resource names"
  default     = "my-troubleshoot-ecs"
  
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
  
}

variable "container_port" {
  type    = number
  default = 80
}