provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "FinPay"
      Environment = "Dev"
      ManagedBy   = "Terraform"
    }
  }
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "finpay-tf-state-k8s-payment-app"
    key          = "envs/dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}