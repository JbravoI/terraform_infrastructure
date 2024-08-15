#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
} 

##################
# Log Analytics #
##################
resource "azurerm_log_analytics_workspace" "logAnalytics" {
  name                = var.log_Analytics_name 
  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = data.azurerm_resource_group.resource-group.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  
  tags                = var.tags
  depends_on = [data.azurerm_resource_group.resource-group]
}