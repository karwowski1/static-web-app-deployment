variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the existing VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in the existing VPC"
  
}

variable "security_group_id_ecs" {
  type        = string
  description = "The security group ID for the ECS service"
  
}

variable "security_group_id_alb" {
  type        = string
  description = "The security group ID for the ALB"
  
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