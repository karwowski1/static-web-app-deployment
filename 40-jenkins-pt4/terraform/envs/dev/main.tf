module "vpc" {
  source = "../../modules/vpc"

  environment          = "dev-app"
  vpc_cidr             = "10.1.0.0/16"
  azs                  = ["eu-central-1a", "eu-central-1b"]
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
  vpc_endpoints        = ["s3", "ecr_api", "ecr_dkr"]
  aws_region           = "eu-central-1"
}

module "app_cluster" {
  source          = "../modules/app_cluster"
  environment     = "dev"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
}
