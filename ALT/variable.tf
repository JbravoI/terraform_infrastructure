#General Variables 
variable "full_customer_name" {
  description = "Name of the customer or client"
  default     = "test"
}
variable "customer_prefix" {
  description = "Prefix name for the customer or client"
  default     = "terra"
}
variable "existing_rg_name" {
  description = "Prefix name for the customer or client"
  default     = "terra"
}
variable "existing_rg" {
  description = "Set to true if you want to use an existing resource group, otherwise false to create a new one."
  type        = bool
  default     = false
}
variable "location" {
  description = "Azure Region location for deployment of resources"
  type        = string
  default     = "eastus"

  validation {
    condition     = contains(["eastus", "westus", "centralus", "northcentralus", "southcentralus", "eastus2", "westus2", "westus3", "australiaeast", "australiasoutheast", "canadacentral", "canadaeast", "japaneast", "japanwest", "uksouth", "ukwest", "francecentral", "germanywestcentral", "norwayeast", "swedencentral", "switzerlandnorth", "uaenorth", "brazilsouth", "brazilsoutheast", "southafricanorth", "southafricawest", "koreacentral", "koreasouth", "indiaeast", "indiacentral", "indiabangalore"], var.location)
    error_message = "Invalid Azure location. Please choose from the allowed list of regions."
  }
}
variable "environment" {
  description = "Azure Subscription for deployment of resources"
  default     = "dev"

  validation {
    condition     = contains(["dev", "pilot", "prod"], var.environment)
    error_message = "Invalid Azure Subscription. Please choose from the allowed list of Subscription."
  }
}
variable "managed_identity" {
  description = "Manage Identity name"
  default     = "managed-identity-xxxx"
  sensitive   = true
}
variable "user_objectid" {
  description = "User Email Address"
  default     = ".com#EXT#@dev.onmicrosoft.com" 
}

###################
# Credentials #
###################
variable "subscription_id" {
  default = "xxxx21e17"
  sensitive   = true
}
variable "client_id" {
  default = "xxxx808532"
  sensitive   = true
}
variable "client_secret" {
  default = "xxxxYct5"
  sensitive   = true
}
variable "tenant_id" {
  default = "xxxx7bb"
  sensitive   = true
}



