output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}
output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.storage_account.primary_connection_string
  sensitive = true
}
output "storage_account_primary_access_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}
output "storage_account_primary_blob_connection_string" {
  value = azurerm_storage_account.storage_account.primary_blob_connection_string
  sensitive = true
}
output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
  sensitive = true
}
# output "container_id" {
#   value = { for id, container_value in azurerm_storage_container.container : id => container_value.id }
# }