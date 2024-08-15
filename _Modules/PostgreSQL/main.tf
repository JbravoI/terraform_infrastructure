data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
}

resource "azurerm_postgresql_flexible_server" "postgre" {
  name                   = var.postgresql_name
  resource_group_name    = data.azurerm_resource_group.resource-group.name
  location               = data.azurerm_resource_group.resource-group.location
  version                = var.postgre_version #"13.11"
  delegated_subnet_id    = var.delegated_subnet_id 
  private_dns_zone_id    = var.private_dns_zone_id  
  administrator_login    = var.administrator_login
  administrator_password = random_password.admin_password.result
  zone                   = "1"
  backup_retention_days        = var.backup_retention 
  storage_mb = var.storage_mb

  sku_name   = var.sku_name
  depends_on = [data.azurerm_resource_group.resource-group]

}

resource "random_password" "admin_password" {
  special = "false"
  length  = 10
}
