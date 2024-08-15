#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}

resource "azurerm_user_assigned_identity" "identity" {
  name     = var.managed_identity
  location =  data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_role_assignment" "role1" {
  principal_id   = azurerm_user_assigned_identity.identity.principal_id
  role_definition_name = "Reader"
  scope          = data.azurerm_resource_group.resource_group.id
}
resource "azurerm_role_assignment" "role2" {
  principal_id   = azurerm_user_assigned_identity.identity.principal_id
  role_definition_name = "Managed Identity Operator"
  scope          = data.azurerm_resource_group.resource_group.id
}
resource "azurerm_role_assignment" "role3" {
  principal_id   = azurerm_user_assigned_identity.identity.principal_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  scope          = data.azurerm_resource_group.resource_group.id
}
resource "azurerm_role_assignment" "role4" {
  principal_id   = azurerm_user_assigned_identity.identity.principal_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope          = data.azurerm_resource_group.resource_group.id
}

resource "azurerm_role_assignment" "aks_to_acr_role" {
  scope                = var.Containerreg_id
  role_definition_name = "AcrPull"
  principal_id         =  var.service_principal 
  skip_service_principal_aad_check = true

  depends_on = [data.azurerm_resource_group.resource_group]
}

resource "azurerm_role_assignment" "search_service_role" {
  scope                = var.storage_account_id_2
  role_definition_name = "Storage Blob Data Reader"
  principal_id         =  var.service_principal 
  skip_service_principal_aad_check = true

  depends_on = [data.azurerm_resource_group.resource_group]
}
