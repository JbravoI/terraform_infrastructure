#General Variables 
variable "full_customer_name" {
  description = "Name of the customer or client"
  default     = "test"
}
variable "customer_prefix" {
  description = "Prefix name for the customer or client"
  default     = "terra"
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
  default     = "managed-identity-xxxx"
}
variable "user_objectid" {
  description = "User Email Address"
  default     = ".com#EXT#@dev.onmicrosoft.com" #"ttiamiyu@arborsys.com"
}


###################
# Credentials #
###################
variable "subscription_id" {
  default = "xxxx21e17"
}
variable "client_id" {
  default = "xxxx808532"
}
variable "client_secret" {
  default = "xxxxYct5"
}
variable "tenant_id" {
  default = "xxxx7bb"
}

###################
# Kubernetes Cluster #
###################
variable "kubernetes_version" {
  default = "1.27.9"
}
variable "db_node_pool_max_count" {
  default = "1"
}
variable "db_node_pool_min_count" {
  default = "1"
}
variable "cps_node_pool_max_count" {
  default = "1"
}
variable "cps_node_pool_min_count" {
  default = "1"
}
variable "app_node_pool_max_count" {
  default = "1"
}
variable "app_node_pool_min_count" {
  default = "1"
}
variable "sp_client_secret" {
  default = "xxxxxxaUP"
}
variable "vm_size" {
  default = "Standard_B4ms"
}

###################
# Container Registry #
###################
variable "cr_sku" {
  default = "Basic"
}
variable "public_network_access_enabled" {
  default = "true"
}

###################
# Postgres Database #
###################
variable "pg_administrator_login" {
  default = "postgres"
}
variable "pg_sku_name" {
  default = "GP_Standard_D4s_v3"
}
variable "storage_mb" {
  default = 32768
}
variable "pg_backup_retention" {
  default = 30
}
variable "postgre_version" {
  default = "13"
}

##################
# Search Service #
##################
variable "search_service_sku" {
  default = "standard"
}

###################
# Storage Account #
# ###################
variable "account_tier" {
  default = "Standard"
}
variable "account_replication_type" {
  default = "LRS"
}
variable "min_tls_version" {
  default = "TLS1_2"
}

###################
# Keyvault Secrets #
###################
variable "key_vault_sku" {
  default = "standard"
}
variable "IN_AZURE_SEARCH_KEY" {
  default = ""
}
variable "IN_AZURE_STORAGE_ACCESS_KEY" {
  description = "Storage accounts => Select storage => Access keys => key1"
  default     = "xxxx"
}
variable "IN_CLIENT_WIJMO_KEY" {
  description = "Create a new wijmo key and add encoded string"
  default     = "tempid"
}
variable "IN_COOKIE_PASSWORD" {
  description = "Cookie password"
  default     = "xxxxxx"
}
variable "IN_EMAIL_PASSWORD" {
  description = "Email password"
  default     = "xxxxx"
}
variable "IN_SHARED_KEY" {
  description = "xxxxxx password"
  default     = "xxxxxx"
}
variable "IN_DB_PASSWORD" {
  description = "OrientDB Database Password"
  default     = "300C4AyWR8y0fAF6alNizedb9uT27sld"
}
variable "IN_CACHE_REDIS_PASSWORD" {
  description = "Redis Database Password"
  default     = "gyDWABOowsEONxii5a7zOtU8OwZNUlsz"
}
variable "IN_PG_DB_PASSWORD" {
  description = "Postgres Database Password"
  default     = "Pyojmt6jo4plwe"
}
variable "IN_CO_REVIEW_ACCESS_KEY" {
  description = "IN_CO_REVIEW_ACCESS_KEY"
  default     = ""
}
variable "IN_CO_REVIEW_IMPERSONATION_ACCESS_KEY" {
  description = "IN_CO_REVIEW_IMPERSONATION_ACCESS_KEY"
  default     = ""
}
variable "IN_CLIENT_SECRET" {
  description = ""
  default     = "tempid"
}
variable "xxxxxx_LICENSE" {
  description = "xxxxxx_LICENSE"
  default     = "xxxxPT09"
}
variable "IN_CONNECTORS" {
  description = "IN_CONNECTORS"
  default     = "tempid"
}
variable "IN_CO_AUTH_CLIENT_ID" {
  description = "CO_AUTH CLIENT ID and to be updated through application post deployment"
  default     = "xxxxx"
}
variable "IN_CO_AUTH_CLIENT_SECRET" {
  description = "CO_AUTH CLIENT SECRET and to be updated through application post deployment"
  default     = "xxxxx"
}
variable "IN_CO_AUTH_TENANT_ID" {
  description = "CO_AUTH TENANT ID and to be updated through application post deployment"
  default     = "xxxxxx"
}
variable "IN_CO_AUTH_REFRESH_TOKEN" {
  description = "CO_AUTH REFRESH TOKEN and to be updated through application post deployment"
  default     = "xxxxxx"
}
variable "IN_APPINSIGHTS_INSTRUMENTATIONKEY" {
  description = "IN_APPINSIGHTS_INSTRUMENTATIONKEY"
  default     = "xxxxxx"
}