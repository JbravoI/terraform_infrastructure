output "object_id" {
  value = azuread_application.app.object_id
}
output "application_id" {
  value = azuread_application.app.application_id #Otherwise known as "Client ID"
}

output "azuread_secret_uuid" {
  value = azuread_application_password.secret.key_id
}
output "azuread_secret" {
  value = azuread_application_password.secret.value
  sensitive = true  
}