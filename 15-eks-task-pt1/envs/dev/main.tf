module "vpc" {
  source = "../../modules/vpc"

  region             = "eu-central-1"
  project_name       = "eks-learning"
  cluster_name       = "moj-pierwszy-eks"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_a_cidr = "10.0.1.0/24"
  public_subnet_b_cidr = "10.0.2.0/24"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.public_subnet_ids
}