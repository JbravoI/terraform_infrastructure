
variable "display_name" {
  description = "Name of the App"
  default     = "temp"
}
variable "sign_in_audience" {
  description = "Sign in Audience"
  default     = "AzureADMyOrg"
}
variable "owners" {
  description = "Set of Owners"
  default     = ["value"]
}
variable "required_resource_access" {
    description = "Required Resources accessing the App registration looping. A default value as this needs to be set"
  # type = list(object({ #EXAMPLE SYNTAX of what the variable is looking for
  #   resource_app_id = string
  #   resource_access = list(object({
  #     id   = string
  #     type = string
  #   }))
  # }))

  # default = [{
  #   resource_app_id = "00000003-0000-0000-c000-000000000000"
  #   resource_access = [{
  #     id   = "id-number"
  #     type = "Role"
  #   }]
  # }]
}

variable "api_req_acc_token" {
  description = "Requested access token version"
  default     = 1
}

variable "need_identifier_uris" {
  description = "Ture or false on need for identifier URI"
  default = false
}

variable "identifier_uris" {
  description = "List of identifier URIs"
  default = ["placeholder"]
}

variable "need_single_page_application" {
  description = "Ture or false on need for identifier URI"
  default = false
}

variable "single_page_application" {
  description = "Looping single page application variable"
  default = null
}

variable "web_access_token" {
  description = "Web access token issuance boolean"
  default = false
}

variable "web_id_token" {
  description = "Web id token issuance boolean"
  default = false
}

variable "secret_name" {
  description = "Name of the secret"
  default     = "default"
}