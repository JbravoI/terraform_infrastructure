#General Variables 
variable "rg_name" {
  description = "Name of the resource group to be imported."
  default     = "temp-rg"
}
variable "tags" {
  description = "The tags to associate with your resource(s)"
  type        = map(string)
  default = {
    environment = "temp"
  }
}

#Key Vault specific variables 
variable "keyvault_access_policy" {
  description = "Keyvault access policy for Looping"
  # default     = "temp"
  type = map(string)
}
variable "key_vault_name" {
  description = "Name of the key vault"
  default     = "temp-kv"
}
variable "key_vault_sku" {
  description = "SKU of the key vault"
  default     = "standard"
}
variable "tenant_id" {
  description = "Tenant ID"
  default     = "tempid"
}
variable "keyvault_secret" {
  description = "Keyvault Secret"
  default     = "temp"
}
variable "secret_name" {
  description = "Tenant ID"
  default     = "tempid"
}
variable "secret_value" {
  description = "Tenant ID"
  default     = "tempid"
}
variable "identity_id" {
  description = "Tenant ID"
  default     = "tempid"
}
variable "sp_objectid" {
  description = "Tenant ID"
  default     = "tempid"
}
variable "user_objectid" {
  description = "Tenant ID"
  default     = "tempid"
}

