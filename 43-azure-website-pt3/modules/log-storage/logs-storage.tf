resource "azurerm_storage_account" "logs" {
  name                     = "stlog${var.project_name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}

resource "azurerm_storage_management_policy" "logs_lifecycle" {
  storage_account_id = azurerm_storage_account.logs.id

  rule {
    name    = "delete-logs-older-than-30-days"
    enabled = true
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["insights-logs-"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 30
      }
      version {
        delete_after_days_since_creation = 30
      }
    }
  }
}
