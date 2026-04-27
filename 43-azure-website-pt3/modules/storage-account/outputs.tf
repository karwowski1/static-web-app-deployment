output "primary_web_host" {
  value = azurerm_storage_account.static_web.primary_web_host
}

output "storage_account_name" {
  value = azurerm_storage_account.static_web.name
}
