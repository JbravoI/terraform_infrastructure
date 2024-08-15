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

variable "search_service_name" { 
  description = "search service name"
}
variable "search_service_sku" { 
  description = "service principal id"
}
variable "subnet_id" {
  description = "subnet_id"
}
variable "vnet_id" {
  description = "vnet_id"
}
variable "search_service_private_dns_name" {
  description = "search_service_private_dns_name"
}
variable "storage_account_id" {
  description = "storage_account_id"
}
variable "partition_count" {
  description = "partition_count"
}
variable "replica_count" {
  description = "replica_count"
}