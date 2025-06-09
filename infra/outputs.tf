output "frontend_url" {
  value = azurerm_linux_web_app.frontend.default_hostname
}

output "function_app_url" {
  value = azurerm_linux_function_app.backend.default_hostname
}

output "storage_account_url" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "keyvault_uri" {
  value = azurerm_key_vault.vault_blobclient.vault_uri
}
