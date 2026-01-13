terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "s3-static-app-v2-state"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

