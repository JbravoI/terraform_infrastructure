#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}

####################
# Storage Services #
####################
# Create Azure Storage Account 
resource "azurerm_storage_account" "storage_account" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  name                     = var.name 
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind 
  is_hns_enabled           = var.is_hns_enabled 
  min_tls_version          = var.min_tls_version 

  tags                     = var.tags
  depends_on               = [data.azurerm_resource_group.resource_group]
}

# resource "azurerm_storage_container" "container" {
#   for_each              = var.sta_containers
#   storage_account_name  = azurerm_storage_account.storage_account.name
#   name                  = each.value["container_name"] 
#   container_access_type = lookup(each.value, "container_access_type", "private") 

#   depends_on            = [azurerm_storage_account.storage_account]
# }


