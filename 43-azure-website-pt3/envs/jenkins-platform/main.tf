module "resource_group" {
  source       = "../../modules/resource-group"
  project_name = var.project_name
  location     = var.location
  tags         = var.common_tags
}

module "jenkins" {
  source              = "../../modules/jenkins"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vm_size             = var.vm_size
}
