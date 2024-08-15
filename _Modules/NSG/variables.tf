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
# NSG #
################
variable "nsg_name" { 
  description = "NSG Name"
  default     = "temp-nsg-name"
}

variable "subnet_id" { 
  description = "NSG Name"
  default     = "temp-nsg-name"
}