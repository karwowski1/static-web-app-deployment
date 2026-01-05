terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # KONFIGURACJA REMOTE STATE (Podmień wartości!)
  backend "s3" {
    bucket         = "tfstate-part2-lock"                       # np. terraform-state-jan-kowalski
    key            = "task-2/terraform.tfstate"                 # Ścieżka do pliku wewnątrz bucketa
    region         = "eu-west-2"                                # Twój region (np. eu-central-1 lub eu-west-2)
    dynamodb_table = "ts-locks"                                 # Nazwa Twojej tabeli DynamoDB
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2" # Upewnij się, że to ten sam region co wyżej
}