resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${var.source_folder}/index.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "404_html" {
  name                   = "404.html"
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${var.source_folder}/404.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "500_html" {
  name                   = "500.html"
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${var.source_folder}/500.html"
  content_type           = "text/html"
}
