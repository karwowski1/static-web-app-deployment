resource "azurerm_cdn_frontdoor_profile" "profile" {
  name                = "afd-prof-${var.project_name}"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "afde-${var.project_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "static_origin_group" {
  name                     = "default-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  session_affinity_enabled = false

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "static_origin" {
  name                           = "staticweborigin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.static_origin_group.id
  enabled                        = true
  host_name                      = var.storage_host_name
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.storage_host_name
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "default_route" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.static_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.static_origin.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = true
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                              = "waf${var.project_name}"
  resource_group_name               = var.resource_group_name
  sku_name                          = azurerm_cdn_frontdoor_profile.profile.sku_name
  enabled                           = true
  mode                              = "Prevention"
  redirect_url                      = null
  custom_block_response_status_code = 403

  custom_rule {
    name                           = "RateLimitRule"
    enabled                        = true
    priority                       = 100
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "RateLimitRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["0.0.0.0/0"]
    }
  }

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_security_policy" "security_policy" {
  name                     = "afdsp-${var.project_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.endpoint.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name               = "diag-afd-${var.project_name}"
  target_resource_id = azurerm_cdn_frontdoor_profile.profile.id
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
