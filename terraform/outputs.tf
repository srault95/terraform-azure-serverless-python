output "primary_connection_string" {
  description = "Storage Account Primary Connection String"
  value       = azurerm_storage_account.storage.primary_connection_string
}

output "function_app_id" {
  description = "Id of the created Function App"
  value       = azurerm_function_app.func.id
}

output "function_app_identity" {
  value       = azurerm_function_app.func.identity[*].principal_id
  description = "Principal ID from Managed Identity of the Function App"
}

output "function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = azurerm_function_app.func.connection_string
}

output "function_app_url" {
  description = "URL of idefix function"
  value       = "https://${azurerm_function_app.func.default_hostname}"
}

output "function_app_source_control" {
 description = "Source Control of the created Function App"
 value       = "${azurerm_function_app.func.source_control[0].repo_url}/${azurerm_function_app.func.name}.git"
}

output "function_app_source_control_username" {
 description = "Source Control Username of the created Function App"
 value       = azurerm_function_app.func.site_credential[0].username
}

output "function_app_source_control_password" {
  description = "Source Control Password of the created Function App"
  value       = azurerm_function_app.func.site_credential[0].password
}

output "azurerm_function_app_command_keys" {
  description = "Command for retrieve Function App Host Keys"
  value       = "az rest --method post --uri ${data.azurerm_resource_group.rg.id}/providers/Microsoft.Web/sites/${azurerm_function_app.func.name}/host/default/listKeys?api-version=2018-11-01 --query functionKeys.default -o tsv"
}

output "instrumentation_key" {
  value = azurerm_application_insights.insights.instrumentation_key
}
