#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = data.azurerm_resource_group.resource-group.location

  name                      = var.key_vault_name
  sku_name                  = var.key_vault_sku
  tenant_id                 = var.tenant_id
  enable_rbac_authorization = false 

  tags                      = var.tags
  depends_on = [data.azurerm_resource_group.resource-group]
}

# resource "azurerm_key_vault_access_policy" "access-policy" {
#   for_each            = var.keyvault_access_policy  
#   key_vault_id        = azurerm_key_vault.kv.id
#   tenant_id           = each.value["tenant_id"] 
#   object_id           = each.value["object_id"] 

#   certificate_permissions = lookup(each.value, "certificate_permissions", [])
#   key_permissions         = lookup(each.value, "key_permissions", [])
#   secret_permissions      = lookup(each.value, "secret_permissions", []) 

#   depends_on = [azurerm_key_vault.kv]
# }

# resource "azurerm_key_vault_secret" "example_secret" {
#   name         = var.secret_name
#   value        = var.secret_value
#   key_vault_id = azurerm_key_vault.kv.id
# }

resource "azurerm_key_vault_secret" "secret" {
  for_each     = var.keyvault_secret  
  key_vault_id = azurerm_key_vault.kv.id
  name         = each.value["secret_name"]
  value        = each.value["secret_value"]
  lifecycle {
    ignore_changes = [value]
  }    
  depends_on = [azurerm_key_vault.kv, azurerm_key_vault_access_policy.managed_identity, azurerm_key_vault_access_policy.service_principal ] #, azurerm_key_vault_access_policy.access-policy]
}

######
resource "azurerm_key_vault_access_policy" "managed_identity" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id #data.azurerm_client_config.current.tenant_id
  object_id    = var.identity_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
    "Update", "Verify", "WrapKey"
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}

# data "azuread_service_principal" "sp" {
#   display_name = "In-dev"
# }

resource "azurerm_key_vault_access_policy" "service_principal" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.sp_objectid 

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
    "Update", "Verify", "WrapKey"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", 
    "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]
}


data "azuread_user" "user" {
  user_principal_name = var.user_objectid
}
resource "azurerm_key_vault_access_policy" "user_object" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = data.azuread_user.user.object_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
    "Update", "Verify", "WrapKey"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", 
    "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]
}