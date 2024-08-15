#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}


resource "azurerm_search_service" "search_service" {
  name                = var.search_service_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  sku                 = var.search_service_sku
  partition_count     = 1
  replica_count       = 1

  identity {
      type = "SystemAssigned"
    }

  depends_on = [data.azurerm_resource_group.resource_group]
}


############Private Endpoint for Search Service
resource "azurerm_private_dns_zone" "pdns_st_ss" {
  name                = var.search_service_private_dns_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_private_endpoint" "pep_st_ss" {
  name                = "pe_searchservice_vnet"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "sc-ss"
    private_connection_resource_id = azurerm_search_service.search_service.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-ss"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdns_st_ss.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_lnk_ss" {
  name                  = "lnk-dns-vnet-ss"
  resource_group_name   = data.azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.pdns_st_ss.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "dns_a_sta_ss" {
  name                = "sta_a_record_ss"
  zone_name           = azurerm_private_dns_zone.pdns_st_ss.name 
  resource_group_name = data.azurerm_resource_group.resource_group.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.pep_st_ss.private_service_connection.0.private_ip_address]
}

resource "azurerm_search_shared_private_link_service" "SA_SS_endpoint" {
  name               = "SA_SS_endpoint"
  search_service_id  = azurerm_search_service.search_service.id
  subresource_name   = "blob"
  target_resource_id = var.storage_account_id
  request_message    = "request for private connection between SS and SA"
}