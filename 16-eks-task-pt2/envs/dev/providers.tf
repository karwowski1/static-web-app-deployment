terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket       = "eks-task2-tf-state"
    key          = "envs/dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    
    use_lockfile = true 
  }
}

provider "aws" {
  region = var.region
}