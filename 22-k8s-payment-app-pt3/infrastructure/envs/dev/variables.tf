variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
  
}

variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
  default     = "FinPay-pt3"
  
}