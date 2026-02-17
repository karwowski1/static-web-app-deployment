variable "aws_region" {
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project Name"
  default     = "finpay"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "FinPaySecretPass123!"
}