output "cdn_endpoint_hostname" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}

output "profile_id" {
  value = azurerm_cdn_frontdoor_profile.profile.id
}
