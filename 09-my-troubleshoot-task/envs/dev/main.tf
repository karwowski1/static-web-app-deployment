module "networking" {
  source   = "../../modules/networking"
  vpc_cidr = var.vpc_cidr
}

module "alb" {
  source     = "../../modules/alb"
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.public_subnet_ids
}

module "ecs" {
  source                = "../../modules/ecs"
  name                  = var.name
  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.private_subnet_ids
  container_port        = var.container_port
  aws_region            = var.aws_region
  ecr_repository_url    = module.ecr.repository_url
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
}

module "ecr" {
  source = "../../modules/ecr"
  name = var.name
  
}