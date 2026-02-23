module "vpc" {
    source = "../../modules/vpc"
    
    project_name = var.project_name
    aws_region   = var.aws_region
    }

module "ecr" {
    source = "../../modules/ecr"
}

module "rds" {
    source = "../../modules/rds"
    
    project_name = var.project_name
    db_password = var.db_password
    vpc_id      = module.vpc.vpc_id
    vpc_cidr_block = "10.0.0.0/16"
    private_subnet_ids = module.vpc.private_subnets
}

module "eks" {
  source = "../../modules/eks"

  project_name       = var.project_name
  
  # Podpinamy sieć przekazując wartości z modułu VPC do zmiennych modułu EKS
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}