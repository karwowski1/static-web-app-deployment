variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Two public subnet CIDRs (one per AZ)"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Two private subnet CIDRs (one per AZ)"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "name" {
  type        = string
  description = "Prefix for resource names"
  default     = "troubleshoot-ecs"
}

variable "alb_health_check_path" {
  type        = string
  description = "ALB Target Group health check path"
  default     = "/"
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}