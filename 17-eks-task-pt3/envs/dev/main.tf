module "vpc" {
  source = "../../modules/vpc"

  region                = var.region
  project_name          = "eks-learning"
  cluster_name          = var.cluster_name
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_a_cidr  = "10.0.1.0/24"
  public_subnet_b_cidr  = "10.0.2.0/24"
  private_subnet_a_cidr = "10.0.3.0/24"
  private_subnet_b_cidr = "10.0.4.0/24"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name              = var.cluster_name
  subnet_ids                = module.vpc.public_subnet_ids
  private_subnet_ids        = module.vpc.private_subnet_ids
  bastion_role_arn          = module.bastion.bastion_role_arn
  bastion_security_group_id = module.bastion.bastion_security_group_id
}

module "bastion" {
  source = "../../modules/bastion"

  project_name = var.project_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.private_subnet_ids[0]
}

