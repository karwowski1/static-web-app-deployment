resource "azurerm_subnet" "public" {
  count                = length(var.public_subnets)
  name                 = "snet-pub-${var.project_name}-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnets[count.index]]
}

resource "azurerm_subnet" "private" {
  count                = length(var.private_subnets)
  name                 = "snet-priv-${var.project_name}-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnets[count.index]]

  delegation {
    name = "aca-delegation"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

