output "kv_id" {
  value = azurerm_key_vault.kv.id
}
output "secret_id" {
  value = { for id, secret_value in azurerm_key_vault_secret.secret : id => secret_value.id }
}


#   keyvault_access_policy = {
#     service-principal = {
#       tenant_id = data.azuread_client_config.current.tenant_id
#       object_id = module.kube.service_principal_id #data.azurerm_service_principal.service_principal.object_id
#       # certificate_permissions = [
#       #   "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", 
#       #   "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
#       # ]
#       # key_permissions = [
#       #   "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
#       #   "Update", "Verify", "WrapKey"
#       # ]
#       secret_permissions = [
#         "Get", "List", "Set"
#       ]
#     },
#     managed_identity = {
#       tenant_id = data.azuread_client_config.current.tenant_id
#       object_id = module.role_assignment.identity_id
#       certificate_permissions = [
#         "Create", "List", "Delete", "Import", "List", "Update"
#       ]
#       # key_permissions = [
#       #   "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
#       #   "Update", "Verify", "WrapKey"
#       # ]
#       secret_permissions = [
#         "Get", "List", "Set"
#       ]
#     },
#     azuread = {
#       tenant_id = data.azurerm_client_config.current.tenant_id
#       object_id = module.azure_ad.object_id
#       certificate_permissions = [
#         "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", 
#         "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
#       ]
#       key_permissions = [
#         "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
#         "Update", "Verify", "WrapKey"
#       ]
#       secret_permissions = [
#         "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
#       ]
#     }
#   }
#   keyvault_secret = {
#     postgre_password = {
#       secret_name  = "postgre_password"
#       secret_value = module.postgresql.postgre_password
#     }, 
#     storage-connection-string = {
#       secret_name  = "StorageConnectionString"
#       secret_value = module.storage_Account.storage_account_primary_connection_string
#     }
#   }