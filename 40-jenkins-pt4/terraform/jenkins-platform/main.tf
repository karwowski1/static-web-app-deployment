module "vpc" {
  source = "../modules/vpc"

  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["eu-central-1a", "eu-central-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  vpc_endpoints        = ["s3", "ecr_api"]
  aws_region           = "eu-central-1"
}

module "jenkins" {
  source      = "../modules/jenkins"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_ids[0]
  my_ip       = "78.88.142.21/32"
}
