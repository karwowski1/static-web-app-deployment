resource "azurerm_public_ip" "appgw_pip" {
  name                = "appgw-pip-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags

}

locals {
  backend_address_pool_name      = "aca-backend-pool"
  frontend_port_name             = "http-port"
  frontend_ip_configuration_name = "appgw-frontend-ip"
  http_setting_name              = "aca-http-settings"
  listener_name                  = "aca-listener"
  request_routing_rule_name      = "aca-routing-rule"
  probe_name                     = "aca-health-probe"
}

resource "azurerm_application_gateway" "main" {
  name                = "agw-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101S"
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.public_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [var.backend_ip]
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 60
    pick_host_name_from_backend_address = false
    host_name                           = var.backend_fqdn
    probe_name                          = local.probe_name
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  probe {
    name                                      = local.probe_name
    pick_host_name_from_backend_http_settings = false
    host                                      = var.backend_fqdn
    protocol                                  = "Http"
    path                                      = "/health"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3

    match {
      status_code = ["200-399"]
    }
  }


}

resource "azurerm_monitor_diagnostic_setting" "agw_diag" {
  name                       = "agw-diagnostics"
  target_resource_id         = azurerm_application_gateway.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
  }
}
