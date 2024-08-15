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

variable "service_principal" { 
  description = "service principal id"
}
variable "Containerreg_id" { 
  description = "service principal id"
}
variable "storage_account_id_2" { 
  description = "storage_account_id"
}
variable "managed_identity" { 
  description = "service principal id"
  default = "managed-identity-temitwo"
}
variable "managed_identity2" { 
  description = "service principal id"
  default = "managed-identity-temitwo"
}