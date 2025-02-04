#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
} 

##################
# Application Insight #
##################
resource "azurerm_application_insights" "appinsights" {
  name                = var.AppInsight_name
  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = data.azurerm_resource_group.resource-group.location
  application_type    = var.application_type
  workspace_id        = var.logAnalytics_id
  tags                = var.tags
  depends_on = [data.azurerm_resource_group.resource-group]
}

