module "resource_group" {
  source       = "../../modules/resource-group"
  project_name = var.project_name
  location     = var.location
  tags         = var.common_tags
}

module "storage_account" {
  source              = "../../modules/storage-account"
  project_name        = var.project_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = var.common_tags
}

module "cdn" {
  source              = "../../modules/cdn"
  project_name        = var.project_name
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  storage_host_name   = module.storage_account.primary_web_host
  tags                = var.common_tags
}
