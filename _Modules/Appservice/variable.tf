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
# AppService #
################
variable "appserviceplan_sku" {
  default = "Standard"
}
variable "appserviceplan_size" {
  default = "S1"
}
variable "appservice_name" {
  default = "temp"
}
variable "dotnet_framework_version" {
  default = "v4.0"
}
variable "scm_type" {
  default = "LocalGit"
}