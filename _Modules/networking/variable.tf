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

###################

variable "vnet_name" { 
  description = "Vnet Name"
  default     = "vnet-name"
}
variable "Subnet_Name" { 
  description = "Subnet_Name"
}
variable "postgres_subnet_Name" { 
  description = "postgres_subnet_Name"
}
variable "subnet_name_address_space" { 
  description = "default vnet "
  type = list(string)
}
variable "Service_Endpoints" { 
  description = "Service Endpoints"
  type = list(string)
}
variable "vnet_address_space" {
  description = "Address space for VNET"
  type = list(string)
}
variable "postgres_dns_name" {
  description = "postgres dns name"
}
variable "postgres_dns_zone_name" {
  description = "postgres dns name"
}
variable "storage_account_id" {
  description = "storage_account_id"
}
# variable "search_service_id" {
#   description = "search_service_id"
# }

