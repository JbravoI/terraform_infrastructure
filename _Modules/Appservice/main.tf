#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
} 

##################
# AppService #
##################
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${var.appservice_name}-apl"
  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = data.azurerm_resource_group.resource-group.location

  sku {
    tier = var.appserviceplan_sku
    size = var.appserviceplan_size
  } 
}

resource "azurerm_app_service" "appservice" {
  name                = var.appservice_name
  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = data.azurerm_resource_group.resource-group.location
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  site_config {
    dotnet_framework_version = var.dotnet_framework_version
    scm_type                 = var.scm_type
  }

}