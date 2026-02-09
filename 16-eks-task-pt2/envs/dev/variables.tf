variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "eks-task2-tf-state"
  
}

variable "github_repo" {
  description = "GitHub organization name"
  type        = string
  default     = "karwowski1/static-web-app-deployment"
}