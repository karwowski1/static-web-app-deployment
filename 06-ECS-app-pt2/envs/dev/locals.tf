locals {
    environment = "dev"
    project_name = "ecs-app-pt2"
    region = "eu-central-1"
    vpc_cidr = "15.0.0.0/16"

    common_tags = {
        Environment = local.environment
        Project     = local.project_name
        ManagedBy   = "Terraform"
    }
}

