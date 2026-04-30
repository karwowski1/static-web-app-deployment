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

module "website_content" {
  source               = "../../modules/website-content"
  storage_account_name = module.storage_account.storage_account_name
  source_folder        = "${path.module}/../../apps"
}

module "log_storage" {
  source              = "../../modules/log-storage"
  project_name        = var.project_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = var.common_tags
}

module "cdn" {
  source              = "../../modules/cdn"
  project_name        = var.project_name
  resource_group_name = module.resource_group.name
  location            = "global"
  storage_host_name   = module.storage_account.primary_web_host
  tags                = var.common_tags

  log_storage_account_id = module.log_storage.storage_account_id
}

module "monitoring" {
  source                 = "../../modules/monitoring"
  project_name           = var.project_name
  resource_group_name    = module.resource_group.name
  location               = module.resource_group.location
  tags                   = var.common_tags
  cdn_profile_id         = module.cdn.profile_id
  log_storage_account_id = module.log_storage.storage_account_id
}
