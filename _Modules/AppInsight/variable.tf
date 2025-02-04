#General Variables 
variable "rg_name" {
  description = "Name of the resource group to be imported."
  default     = "temp-rg"
}
variable "tags" {
    description = "The tags to associate with your resource(s)"
    type        = map(string)
    default = {
        Environment = "temp"
        Owner = "A"
    }
}

# Application Insight #
variable "AppInsight_name" {
  description = "Name of Log AppInsight"
  default     = "temp-name"
}
variable "logAnalytics_id" {
  description = "ID of Log Analytics"
  default     = "temp-name"
}
variable "application_type" {
  description = "Type of application"
  default     = "web"
}