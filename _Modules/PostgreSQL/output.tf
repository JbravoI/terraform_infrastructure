output "postgre_id" {
  value = azurerm_postgresql_flexible_server.postgre.id
}
output "postgre_password" {
  value = random_password.admin_password.result
}
