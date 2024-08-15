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
  display_name = "InteliNotion-dev"
}

# resource "azuread_group" "ad_terraform" {
#   display_name     = var.ad_group_name
#   owners           = [data.azuread_client_config.current.object_id]
#   security_enabled = true
# }

module "policy_assignments" {
  source = "../_Modules/Azure_policies"
  subscription_id = var.subscription_id
#  container_registry_name = var.container_registry_name
}