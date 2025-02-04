#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
} 

##################
# Funtion App #
##################

resource "azurerm_storage_account" "storageacct" {
  name                     = "${var.funtion_app_name}${random_string.suffix.result}sa"
  resource_group_name      = data.azurerm_resource_group.resource-group.name
  location                 = data.azurerm_resource_group.resource-group.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${var.funtion_app_name}-apl"
  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = data.azurerm_resource_group.resource-group.location

  sku {
    tier = var.appserviceplan_sku
    size = var.appserviceplan_size 
  }
}

resource "azurerm_function_app" "funtion_app" {
  name                       = var.funtion_app_name
  resource_group_name        = data.azurerm_resource_group.resource-group.name
  location                   = data.azurerm_resource_group.resource-group.location
  app_service_plan_id        = azurerm_app_service_plan.appserviceplan.id
  storage_account_name       = azurerm_storage_account.storageacct.name
  storage_account_access_key = azurerm_storage_account.storageacct.primary_access_key
}