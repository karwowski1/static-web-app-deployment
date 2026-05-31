module "resource_group" {
  source       = "../../modules/resource-group"
  project_name = var.project_name
  location     = var.location
  tags         = var.tags
}

module "networking" {
  source              = "../../modules/networking"
  project_name        = var.project_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  vnet_address_space  = var.vnet_address_space
  public_subnets      = var.public_subnet_prefixes
  private_subnets     = var.private_subnet_prefixes
  tags                = var.tags
}

module "acr" {
  source              = "../../modules/acr"
  project_name        = var.project_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.tags
}

module "aca" {
  source                     = "../../modules/aca"
  project_name               = var.project_name
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.resource_group_name
  infrastructure_subnet_id   = module.networking.private_subnet_ids[0]
  acr_login_server           = module.acr.acr_login_server
  acr_username               = module.acr.admin_username
  acr_password               = module.acr.admin_password
  image_name                 = "py-app"
  image_tag                  = "v1"
  log_analytics_workspace_id = module.log_analytics.workspace_id
  tags                       = var.tags
  vnet_id                    = module.networking.vnet_id
}

module "app_gateway" {
  source                     = "../../modules/app-gateway"
  project_name               = var.project_name
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.resource_group_name
  public_subnet_id           = module.networking.public_subnet_ids[0]
  backend_fqdn               = module.aca.fqdn
  backend_ip                 = module.aca.static_ip
  log_analytics_workspace_id = module.log_analytics.workspace_id
  depends_on                 = [module.networking]
  tags                       = var.tags
}

module "log_analytics" {
  source              = "../../modules/log-analytics"
  project_name        = var.project_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.tags
}
