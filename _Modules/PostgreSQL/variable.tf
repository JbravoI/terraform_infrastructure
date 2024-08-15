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

################
# PostGreSQL#
################
variable "postgresql_name" { 
  description = "Container Registry Name"
  default     = "temp-Container-Registry-name"
}
variable "administrator_login" { 
  description = "postgresql_admin_username"
}
variable "sku_name" { 
  description = "postgresql_sku_name"
}
variable "postgre_version" { 
  description = "postgresql_version"
}
variable "storage_mb" { 
  description = "postgresql_version"
}
variable "backup_retention" { 
  description = "postgresql_backup_retention_days"
}
variable "delegated_subnet_id" { 
  description = "postgresql_backup_retention_days"
}
variable "private_dns_zone_id" { 
  description = "postgresql_backup_retention_days"
}