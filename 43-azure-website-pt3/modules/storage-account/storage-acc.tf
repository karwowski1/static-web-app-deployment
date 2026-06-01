resource "azurerm_storage_account" "static_web" {
  name                            = "st${var.project_name}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_account_static_website" "static_web" {
  storage_account_id = azurerm_storage_account.static_web.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

resource "azurerm_storage_container" "web" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.static_web.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account_static_website.static_web]
}
