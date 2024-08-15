#Import existing Resource Group
data "azurerm_resource_group" "resource-group" {
  name = var.rg_name
}

resource "azurerm_kubernetes_cluster" "kube" {
  name                    = var.kubernetes_name
  location                = data.azurerm_resource_group.resource-group.location
  resource_group_name     = data.azurerm_resource_group.resource-group.name
  dns_prefix              = var.dns_prefix
  kubernetes_version      = var.kubernetes_version
  # outbound_type           = var.outbound_type
  # load_balancer_sku       = var.load_balancer_sku
  default_node_pool {
    name       = var.db_node_pool_name
    node_count = 1
    vm_size    = var.vm_size
    enable_auto_scaling     = var.enable_auto_scaling
    max_count               = var.db_node_pool_max_count
    min_count               = var.db_node_pool_min_count
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  # identity {
  #   type = var.identity_type
  # }
  tags                = var.tags
  depends_on = [data.azurerm_resource_group.resource-group]
}

resource "azurerm_kubernetes_cluster_node_pool" "cps" {
  name                  = var.cps_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kube.id
  enable_auto_scaling = var.enable_auto_scaling
  vm_size               = var.vm_size
  node_count            = 1
  max_count = var.cps_node_pool_max_count
  min_count = var.cps_node_pool_min_count
}

resource "azurerm_kubernetes_cluster_node_pool" "app" {
  name                  = var.app_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kube.id
  enable_auto_scaling = var.enable_auto_scaling
  vm_size               = var.vm_size
  node_count            = 1
  max_count = var.app_node_pool_max_count
  min_count = var.app_node_pool_min_count
}