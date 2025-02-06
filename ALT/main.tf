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
# Create a new resource group if 'existing_rg' is false
resource "azurerm_resource_group" "resource_group" {
  count    = var.existing_rg ? 0 : 1
  name     = "${var.customer_prefix}-${var.environment}-rg"
  location = var.location
}

# Reference an existing resource group if 'existing_rg' is true
data "azurerm_resource_group" "resource_group" {
  count    = var.existing_rg ? 1 : 0
  name     = var.existing_rg_name
  location = var.location
}

#Use the appropriate resource group (new or existing) in other resources
# locals {
#   resource_group_name = var.existing_rg
#     ? (length(data.azurerm_resource_group.resource_group) > 0 ? data.azurerm_resource_group.resource_group[0].name : null)
#     : (length(azurerm_resource_group.resource_group) > 0 ? azurerm_resource_group.resource_group[0].name : null)
# }

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

######################
# Application Insight #
######################
module "application-insights" {
  source           = "../_Modules/AppInsight"
  AppInsight_name  = "${var.customer_prefix}-${var.environment}-ap"
  logAnalytics_id  = module.az-log-analytics.log_analytics_id
  rg_name          = azurerm_resource_group.resource_group.name
  application_type = "web"
}

######################
# AppService #
######################
module "app_service" {
  source               = "../_Modules/Appservice"
  appservice_name      = "${var.customer_prefix}-${var.environment}-aps"
  appserviceplan_size  = "S1"
  appserviceplan_sku   = "Standard"
  rg_name              = azurerm_resource_group.resource_group.name
  dotnet_framework_version = "v4.0"
  scm_type             = "LocalGit"
}

##################
# Funtion App #
##################
module "app_service" {
  source               = "../_Modules/FuntionApp"
  funtion_app_name      = "${var.customer_prefix}-${var.environment}-fa"
  appserviceplan_size  = "S1"
  appserviceplan_sku   = "Standard"
  rg_name              = azurerm_resource_group.resource_group.name
  dotnet_framework_version = "v4.0"
  scm_type             = "LocalGit"
  account_tier         = "Standard"
  account_replication_type = "LRS"
}