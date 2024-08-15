output "vnetid" {
  value = azurerm_virtual_network.vnet.id
}

output "default_subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "default_subnet_name" {
  value = azurerm_subnet.subnet.name
}

# output "default_subnets" {
#   value = azurerm_subnet.subnet2
# }

# output "default_subnet_id2" {
#   value = azurerm_subnet.subnet2.id
# }

# output "default_subnet_names2" {
#   value = azurerm_subnet.subnet2.name
# }

output "postgre_subnet_id" {
  value = azurerm_subnet.postgres_subnet.id
}

output "postgre_subnet_name" {
  value = azurerm_subnet.postgres_subnet.name
}

output "postgre_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
}
