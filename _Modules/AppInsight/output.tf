output "instrumentation_key" {
  value = azurerm_application_insights.appinsights.instrumentation_key
  sensitive   = true
}

output "app_id" {
  value = azurerm_application_insights.appinsights.app_id
}