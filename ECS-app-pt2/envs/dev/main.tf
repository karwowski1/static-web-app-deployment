module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = local.vpc_cidr
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  project_name = local.project_name
}

module "ecr" {
  source = "../../modules/ecr"
  project_name = local.project_name
}

module "ecs" {
  source = "../../modules/ecs"
  project_name = local.project_name
  repository_url = module.ecr.repository_url
}