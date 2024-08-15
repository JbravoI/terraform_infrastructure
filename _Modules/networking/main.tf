#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}

#Creates the Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  address_space       = var.vnet_address_space

  tags = var.tags
  depends_on      = [data.azurerm_resource_group.resource_group]
}

# resource "azurerm_subnet" "subnet2" {
#   for_each             = local.subnets
#   name                 = each.key
#   resource_group_name  = data.azurerm_resource_group.resource_group.name
#   virtual_network_name  = azurerm_virtual_network.vnet.name
#   address_prefixes      = var.subnet_name_address_space #[each.value]

#   depends_on      = [azurerm_virtual_network.vnet]
# }

resource "azurerm_subnet" "subnet" {
  name                 = var.Subnet_Name
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_name_address_space
  service_endpoints    = var.Service_Endpoints

  depends_on      = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "postgres_subnet" {
  name                 = var.postgres_subnet_Name
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["11.0.0.32/27"]
  service_endpoints    = ["Microsoft.KeyVault","Microsoft.Sql", "Microsoft.storage"]

  delegation {
    name = "postgreDelegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}


resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = var.postgres_dns_name 
  resource_group_name = data.azurerm_resource_group.resource_group.name

  depends_on      = [azurerm_subnet.subnet]
}
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_zone" {
  name                  = var.postgres_dns_zone_name 
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = data.azurerm_resource_group.resource_group.name

  depends_on      = [azurerm_subnet.subnet]
}

############Private Endpoint for Storage Account (blob)
resource "azurerm_private_dns_zone" "pdns_st" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_private_endpoint" "pep_st" {
  name                = "pe_blobstorage_vnet"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "sc-blob"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdns_st.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_lnk_sta" {
  name                  = "lnk-dns-vnet-blob"
  resource_group_name   = data.azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.pdns_st.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "dns_a_sta" {
  name                = "sta_a_record"
  zone_name           = azurerm_private_dns_zone.pdns_st.name 
  resource_group_name = data.azurerm_resource_group.resource_group.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.pep_st.private_service_connection.0.private_ip_address]
}


############Private Endpoint for Storage Account (File)
resource "azurerm_private_dns_zone" "pdns_st_f" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_private_endpoint" "pep_st_f" {
  name                = "pe_filestorage_vnet"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "sc-file"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdns_st_f.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_lnk_stb" {
  name                  = "lnk-dns-vnet-file"
  resource_group_name   = data.azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.pdns_st_f.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "dns_a_sta_f" {
  name                = "sta_a_record_file"
  zone_name           = azurerm_private_dns_zone.pdns_st_f.name 
  resource_group_name = data.azurerm_resource_group.resource_group.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.pep_st_f.private_service_connection.0.private_ip_address]
}


# ################# Private Endpoint Between SA and SS
# # Define private endpoint connecting Azure Search to Storage Account
# resource "azurerm_private_endpoint" "SA_search_endpoint" {
#   name                = "SA_search-endpoint-private-endpoint"
#   location            = data.azurerm_resource_group.resource_group.location
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   subnet_id           = azurerm_subnet.subnet.id


#   private_service_connection {
#     name                           = "SA_search-private-service-connection"
#     private_connection_resource_id = var.storage_account_id
#     subresource_names              = ["blob"]
#     is_manual_connection           = false
#     request_message                = "request for private connection between SS and SA"
#   }
  
# }