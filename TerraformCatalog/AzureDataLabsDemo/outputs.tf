output "active_user_object_id" {
  value = data.azurerm_client_config.current.object_id
}

output "active_user_client_id" {
  value = data.azurerm_client_config.current.client_id
}