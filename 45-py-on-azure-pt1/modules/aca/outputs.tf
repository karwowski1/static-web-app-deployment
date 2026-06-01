output "fqdn" {
  value = azurerm_container_app.aca.ingress[0].fqdn
}

output "static_ip" {
  value = azurerm_container_app_environment.aca_env.static_ip_address
}
