resource "azurerm_monitor_diagnostic_setting" "afd" {
  name               = "diag-afd-${var.project_name}"
  target_resource_id = var.cdn_profile_id
  storage_account_id = var.log_storage_account_id

  enabled_log {
    category = "FrontDoorAccessLog"
  }

  enabled_log {
    category = "FrontDoorWebApplicationFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_portal_dashboard" "metrics" {
  name                = "dashboard-afd-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dashboard_properties = <<DASH
{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": {
            "x": 0,
            "y": 0,
            "rowSpan": 4,
            "colSpan": 6
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Front Door & WAF Monitor\nMetrics and Blocked Requests",
                  "title": "Static Website Dashboard",
                  "subtitle": "WAF & Traffic"
                }
              }
            }
          }
        }
      }
    }
  },
  "metadata": {
    "model": {
      "timeRange": {
        "value": {
          "relative": {
            "duration": 24,
            "timeUnit": 1
          }
        },
        "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
      }
    }
  }
}
DASH
}
