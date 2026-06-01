resource "azurerm_container_app_environment" "aca_env" {
  name                           = "cae${var.project_name}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = true
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  tags                           = var.tags

}

resource "azurerm_container_app" "aca" {
  name                         = "ca${var.project_name}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  revision_mode                = "Single"

  registry {
    server               = var.acr_login_server
    username             = var.acr_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = var.acr_password
  }

  template {
    min_replicas = 1
    max_replicas = 3

    custom_scale_rule {
      name             = "cpu-scaling"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"
        value = "50"
      }
    }

    container {
      name   = "py-app"
      image  = "${var.acr_login_server}/${var.image_name}:${var.image_tag}"
      cpu    = "0.25"
      memory = "0.5Gi"

      liveness_probe {
        port      = 8080
        transport = "HTTP"
        path      = "/health"
      }
    }
  }

  ingress {
    external_enabled           = true
    target_port                = 8080
    transport                  = "http"
    allow_insecure_connections = true

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "aca_dns" {
  name                = azurerm_container_app_environment.aca_env.default_domain
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca_dns_link" {
  name                  = "aca-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aca_dns.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "aca_wildcard" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.aca_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_container_app_environment.aca_env.static_ip_address]
}
