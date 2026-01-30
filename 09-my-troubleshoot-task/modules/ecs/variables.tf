variable "web_desired_count" {
  type        = number
  description = "Initial desired count for web service"
  default     = 1
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  type        = string
  description = "Prefix for resource names"
  default     = "troubleshoot-ecs"
}

variable "container_port" {
  type        = number
  description = "App container port"
  default     = 80
}

variable "web_min_capacity" {
  type        = number
  description = "Autoscaling min capacity for web service"
  default     = 1
}

variable "web_max_capacity" {
  type        = number
  description = "Autoscaling max capacity for web service"
  default     = 6
}

variable "alb_health_check_path" {
  type        = string
  description = "ALB Target Group health check path"
  default     = "/"
  
}

variable "vpc_id" {
  type        = string
  description = "The ID of the existing VPC"
  
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs in the existing VPC"
}

variable "alb_security_group_id" {
  type        = string
  description = "The security group ID for the ALB"
  
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the ALB target group"
  
}

variable "ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository containing the web app image"
  
}

