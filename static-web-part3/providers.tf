terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

 
  backend "s3" {
    bucket         = "tfstate-part2-lock"                       
    key            = "task-2/terraform.tfstate"                 
    region         = "eu-west-2"                                
    dynamodb_table = "ts-locks"                                 
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2" 
}
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}