output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "app_gateway_public_ip" {
  value = module.app_gateway.public_ip
}
