data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
}

resource "azurerm_container_registry" "Containerreg" {
  name                = var.Container_Registry_name
  location                = data.azurerm_resource_group.resource-group.location
  resource_group_name     = data.azurerm_resource_group.resource-group.name
  sku                 = var.sku
  public_network_access_enabled = var.public_network_access_enabled

  tags                = var.tags
  depends_on = [data.azurerm_resource_group.resource-group]
}

