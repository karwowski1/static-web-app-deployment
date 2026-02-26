module "vpc" {
  source       = "../../modules/vpc"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "ecr" {
  source = "../../modules/ecr"
}

# module "rds" {
#   source = "../../modules/rds"

#   project_name       = var.project_name
#   db_password        = var.db_password
#   vpc_id             = module.vpc.vpc_id
#   vpc_cidr_block     = "10.0.0.0/16"
#   private_subnet_ids = module.vpc.private_subnet_ids
# }

module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "ec2" {
  source = "../../modules/ec2"

  subnet_id      = module.vpc.private_subnet_ids[0]
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  instance_type  = "t3.micro"
}