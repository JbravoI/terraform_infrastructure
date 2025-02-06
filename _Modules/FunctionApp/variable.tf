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
# Funtion App #
################
variable "appserviceplan_sku" {
  default = "temp"
}
variable "appserviceplan_size" {
  default = "temp"
}
variable "funtion_app_name" {
  default = "temp"
}
variable "dotnet_framework_version" {
  default = "temp"
}
variable "scm_type" {
  default = "temp"
}
variable "account_tier" {
  default = "temp"
}
variable "account_replication_type" {
  default = "temp"
}