# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.103.1" # "=2.96.0" Establishes a forced version
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.18.0"
    }
  }

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id #"!__subscription_id__!"
  client_id       = var.client_id       #"!__client_id__!"
  client_secret   = var.client_secret   #"!__client_secret__!"
  tenant_id       = var.tenant_id       #"!__tenant_id__!"
}

provider "azuread" {
  tenant_id = var.tenant_id #"!__tenant_id__!"
}

######################################
# Data Imports of Existing Resources #
######################################
data "azurerm_subscription" "primary" {
}
data "azurerm_client_config" "current" {}

data "azuread_service_principal" "service_principal" {
  display_name = "In-dev"
}
# data "azurerm_service_principal" "service_principal" {
#   application_id = data.azurerm_client_config.current.client_id
# }

##################
# Resource Group # #Creation of new Resource Group would be actual code snippet
##################
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.customer_prefix}-${var.environment}-rg"
  location = var.location
}

######################
# Role Assignment    #
#####################
module "role_assignment" {
  source = "../_Modules/role_assignment"
  # name     = is the variabke file of the module
  rg_name              = azurerm_resource_group.resource_group.name
  service_principal    = data.azuread_service_principal.service_principal.object_id
  Containerreg_id      = module.container-registry.Container_registry_id
  storage_account_id_2 = module.storage_Account.storage_account_id

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group]
}


###################
# Virtual Network #
###################
module "vnet" {
  source                    = "../_Modules/networking"
  rg_name                   = azurerm_resource_group.resource_group.name
  vnet_name                 = "${var.customer_prefix}-${var.environment}-vnet"
  vnet_address_space        = ["11.0.0.0/26"]
  Subnet_Name               = "defaultsbnt"
  postgres_subnet_Name      = "postgresqlsbnt"
  subnet_name_address_space = ["11.0.0.0/27"]
  Service_Endpoints         = ["Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.storage"]
  postgres_dns_name         = "${var.customer_prefix}-${var.environment}-pgflex.postgres.database.azure.com"
  postgres_dns_zone_name    = "${var.customer_prefix}-${var.environment}-pgflex.com"
  storage_account_id        = module.storage_Account.storage_account_id

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group]
}


# ###########################
# # Azure Kubernetes Service #
# ###########################
module "aks" {
  source             = "../_Modules/kubernetes"
  rg_name            = azurerm_resource_group.resource_group.name
  kubernetes_name    = "${var.customer_prefix}-${var.environment}-aks"
  kubernetes_version = var.kubernetes_version
  # public_network_access             = "true"
  dns_prefix              = "${var.customer_prefix}-prefix-name"
  # subnet_id               = module.vnet.default_subnets.subnet1.id
  # subnet_name             = module.vnet.default_subnets.subnet1.name
  subnet_id               = module.vnet.default_subnet_id
  subnet_name             = module.vnet.default_subnet_name
  load_balancer_sku       = "Basic"
  outbound_type           = "loadBalancer"
  enable_auto_scaling     = "true"
  db_node_pool_name       = "dbpool"
  app_node_pool_name      = "apppool"
  cps_node_pool_name      = "cpspool"
  db_node_pool_max_count  = var.db_node_pool_max_count
  db_node_pool_min_count  = var.db_node_pool_min_count
  cps_node_pool_max_count = var.cps_node_pool_max_count
  cps_node_pool_min_count = var.cps_node_pool_min_count
  app_node_pool_max_count = var.app_node_pool_max_count
  app_node_pool_min_count = var.app_node_pool_min_count
  sp_client_id            = data.azuread_service_principal.service_principal.application_id
  sp_client_secret        = var.client_secret
  vm_size                 = var.vm_size
  # identity_type       = "UserAssigned"


  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group, module.vnet]
}


######################
# Container Registry #
#####################
module "container-registry" {
  source                        = "../_Modules/Container_registry"
  Container_Registry_name       = "${var.customer_prefix}${var.environment}cr"
  rg_name                       = azurerm_resource_group.resource_group.name
  sku                           = var.cr_sku
  public_network_access_enabled = var.public_network_access_enabled

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group, module.vnet]
}

###################
# Postgres Database #
###################
module "postgresql" {
  source = "../_Modules/PostgreSQL"

  rg_name = azurerm_resource_group.resource_group.name

  administrator_login = var.pg_administrator_login
  sku_name            = var.pg_sku_name
  postgre_version     = var.postgre_version
  storage_mb          = var.storage_mb
  backup_retention    = var.pg_backup_retention
  delegated_subnet_id = module.vnet.postgre_subnet_id
  private_dns_zone_id = module.vnet.postgre_dns_zone_id
  postgresql_name     = "${var.customer_prefix}-${var.environment}-pg"
  # databases_names     = ["mydatabase"]
  # databases_collation = { mydatabase = "en-US" }
  # databases_charset   = { mydatabase = "UTF8" }
  # logs_destinations_ids = [
  # module.logs.logs_storage_account_id,
  # module.logs.log_analytics_workspace_id]

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group, module.vnet]
}

###################
# Storage Account #
# ###################
module "storage_Account" {
  source                   = "../_Modules/Storage.Account"
  rg_name                  = azurerm_resource_group.resource_group.name
  name                     = "inteli${var.customer_prefix}${var.environment}sa222"
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  min_tls_version          = var.min_tls_version
  # sta_containers            = var.sta_containers

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group]
}

##################
# Log Analytics #
##################
module "az-log-analytics" {
  source             = "../_Modules/LogAnalytics"
  log_Analytics_name = "${var.customer_prefix}-${var.environment}-la"
  rg_name            = azurerm_resource_group.resource_group.name
  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group]
}


##################
# Search Service #
##################
module "search_service" {
  source                          = "../_Modules/search_service"
  rg_name                         = azurerm_resource_group.resource_group.name
  search_service_name             = "${var.customer_prefix}-${var.environment}-ss4"
  search_service_sku              = var.search_service_sku
  search_service_private_dns_name = "${var.customer_prefix}-ss.privatelink.search.windows.net"
  subnet_id                       = module.vnet.default_subnet_id
  vnet_id                         = module.vnet.vnetid
  partition_count                 = 1
  replica_count                   = 1
  storage_account_id              = module.storage_Account.storage_account_id

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group, module.vnet, module.storage_Account]
}


##########################
# Network Security Group #
##########################

module "network-security-group" {
  source               = "../_Modules/NSG"
  rg_name              = azurerm_resource_group.resource_group.name
  nsg_name             = "${var.customer_prefix}-${var.environment}-nsg"
  subnet_id              = module.vnet.default_subnet_id

  tags = {
    Environment : var.environment
  }
  depends_on = [azurerm_resource_group.resource_group, module.vnet]
}

##########
#KeyVault #
###########
module "keyVault" {
  source   = "../_Modules/Key.Vault"
  rg_name        = azurerm_resource_group.resource_group.name 
  key_vault_name = "${var.customer_prefix}-${var.environment}-5vlt"
  key_vault_sku = var.key_vault_sku
  tenant_id      = var.tenant_id
  identity_id = module.role_assignment.identity_principal_id
  sp_objectid = data.azuread_service_principal.service_principal.object_id
  user_objectid = var.user_objectid

  keyvault_access_policy = {
  }
  keyvault_secret = {
    storage-connection-string = {
      secret_name  = "StorageConnectionString"
      secret_value = module.storage_Account.storage_account_primary_connection_string
    }, 
    IN-AZURE-SEARCH-KEY = {
      secret_name  = "IN-AZURE-SEARCH-KEY"
      secret_value = var.IN_AZURE_SEARCH_KEY
    }, 
    IN-AZURE-STORAGE-ACCESS-KEY = {
      secret_name  = "IN-AZURE-STORAGE-ACCESS-KEY"
      secret_value = module.storage_Account.storage_account_primary_access_key
    }, 
    IN-AZURE-STORAGE-CONNECTION-STRING = {
      secret_name  = "IN-AZURE-STORAGE-CONNECTION-STRING"
      secret_value = module.storage_Account.storage_account_primary_connection_string
    }, 
    IN-CLIENT-WIJMO-KEY = {
      secret_name  = "IN-CLIENT-WIJMO-KEY"
      secret_value = var.IN_CLIENT_WIJMO_KEY
    }, 
    IN-COOKIE-PASSWORD = {
      secret_name  = "IN-COOKIE-PASSWORD"
      secret_value = var.IN_COOKIE_PASSWORD
    }, 
    IN-EMAIL-PASSWORD = {
      secret_name  = "IN-EMAIL-PASSWORD"
      secret_value = var.IN_EMAIL_PASSWORD
    }, 
    IN-SHARED-KEY = {
      secret_name  = "IN-SHARED-KEY"
      secret_value = var.IN_SHARED_KEY
    }, 
    IN-DB-PASSWORD = {
      secret_name  = "IN-DB-PASSWORD"
      secret_value = var.IN_DB_PASSWORD
    }, 
    IN-CACHE-REDIS-PASSWORD = {
      secret_name  = "IN-CACHE-REDIS-PASSWORD"
      secret_value = var.IN_CACHE_REDIS_PASSWORD
    }, 
    IN-PG-DB-PASSWORD = {
      secret_name  = "IN-PG-DB-PASSWORD"
      secret_value = module.postgresql.postgre_password
    }, 
    IN-CO-REVIEW-ACCESS-KEY = {
      secret_name  = "IN-CO-REVIEW-ACCESS-KEY"
      secret_value = var.IN_CO_REVIEW_ACCESS_KEY
    }, 
    IN-CO-REVIEW-IMPERSONATION-ACCESS-KEY = {
      secret_name  = "IN-CO-REVIEW-IMPERSONATION-ACCESS-KEY"
      secret_value = var.IN_CO_REVIEW_IMPERSONATION_ACCESS_KEY
    }, 
    IN-CLIENT-SECRET = {
      secret_name  = "IN-CLIENT-SECRET"
      secret_value = var.IN_CLIENT_SECRET
    },
    IN-CONNECTORS = {
      secret_name  = "IN-CONNECTORS"
      secret_value = var.IN_CONNECTORS
    }, 
    IN-CO-AUTH-CLIENT-ID = {
      secret_name  = "IN-CO-AUTH-CLIENT-ID"
      secret_value = var.IN_CO_AUTH_CLIENT_ID
    }, 
    IN-CO-AUTH-CLIENT-SECRET = {
      secret_name  = "IN-CO-AUTH-CLIENT-SECRET"
      secret_value = var.IN_CO_AUTH_CLIENT_SECRET
    }, 
    IN-CO-AUTH-TENANT-ID = {
      secret_name  = "IN-CO-AUTH-TENANT-ID"
      secret_value = var.IN_CO_AUTH_TENANT_ID
    }, 
    IN-CO-AUTH-REFRESH-TOKEN = {
      secret_name  = "IN-CO-AUTH-REFRESH-TOKEN"
      secret_value = var.IN_CO_AUTH_REFRESH_TOKEN
    }, 
    IN-APPINSIGHTS-INSTRUMENTATIONKEY = {
      secret_name  = "IN-APPINSIGHTS-INSTRUMENTATIONKEY"
      secret_value = var.IN_APPINSIGHTS_INSTRUMENTATIONKEY
    }
  }

  tags = {
      Environment: var.environment
  }
  depends_on  = [azurerm_resource_group.resource_group,
                 module.storage_Account, module.postgresql, module.role_assignment]
}

# resource "null_resource" "run_permission_script" {
#   triggers = {
#      script_hash = sha256("./ImportImages.ps1")
#   }

#   provisioner "local-exec" {
#     command = "./ImportImages.ps1"
#     interpreter = ["pwsh", "-Command"]
#   }
#   depends_on  = [azurerm_resource_group.resource_group,
#                  module.storage_Account, module.postgresql, module.role_assignment, module.container-registry]
# }