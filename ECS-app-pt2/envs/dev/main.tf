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
  project_name       = local.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  container_image    = module.ecr.repository_url
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
}