#General Variables 
variable "full_customer_name" {
  description = "Name of the customer or client"
  default     = "test"
}
variable "customer_prefix" {
  description = "Prefix name for the customer or client"
  default     = "test"
}
variable "location" {
  description = "Azure Region location for deployment of resources"
  default     = "east us"
}
variable "environment" {
  description = "Environment tag value"
  default     = "dev"
}
variable "managed_identity" {
  description = "Manage Identity name"
  default     = "managed-identity-temi"
}
variable "user_objectid" {
  description = "User Email Address"
  default     = "com#EXT#@dev.onmicrosoft.com" 
}


###################
# Credentials #
###################
variable "subscription_id" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "tenant_id" {
  default = ""
}

##AD GROUP
variable "ad_group_name" {
  default = "tf test grp"
}
variable "container_registry_name" {
  default = "dryruntemicr"
  description = "container_registry_name"
}