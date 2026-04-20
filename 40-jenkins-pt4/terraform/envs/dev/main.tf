

module "app_cluster" {
  source          = "../modules/app_cluster"
  environment     = "dev"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
}
