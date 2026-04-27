resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${var.source_folder}/index.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "4xx_html" {
  name                   = "4xx.html"
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${var.source_folder}/4xx.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "5xx_html" {
  name                   = "5xx.html"
  storage_account_name   = var.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${var.source_folder}/5xx.html"
  content_type           = "text/html"
}
