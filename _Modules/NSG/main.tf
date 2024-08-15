#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = data.azurerm_resource_group.resource-group.location
  resource_group_name = data.azurerm_resource_group.resource-group.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet" {
  subnet_id                 = var.subnet_id
  network_security_group_id  = azurerm_network_security_group.nsg.id
}

# resource "azurerm_subnet_network_security_group_association" "example" {
#   for_each                   = var.subnets
#   subnet_id                 = each.value.id
#   network_security_group_id  = azurerm_network_security_group.nsg.id
# }
