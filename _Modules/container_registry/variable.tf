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
# Container Registry #
################
variable "Container_Registry_name" { 
  description = "Container Registry Name"
  default     = "temp-Container-Registry-name"
}
variable "sku" { 
  description = "Can be set Basic, standard or Premium"
}
variable "public_network_access_enabled" { 
  description = "Can be set true or false"
}