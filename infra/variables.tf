variable "subscription_id" {
  description = "ID da assinatura do Azure"
  type        = string  
}

variable "sufix_resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
  default     = "rg-blobclient"
}

variable "location" {
  description = "Localização da infraestrutura"
  type        = string
  default     = "Brazil South"
}

variable "sufix_storage_account_name" {
  description = "Nome da conta de armazenamento"
  type        = string
  default     = "sablobclient"
}

variable "sufix_key_vault_name" {
  description = "Nome do Key Vault"
  type        = string
  default     = "kv-blobclient"
}
variable "sufix_key_vault_secret_storage_name" {
  description = "Nome do segredo no Key Vault para a chave de acesso ao Blob"
  type        = string
  default     = "kvs-storage-blobclient"

}

variable "sufix_key_vault_secret_azcredentials_name" {
  description = "Nome do segredo no Key Vault para a chave de acesso ao Azure Credentials"
  type        = string
  default     = "kvs-azcredentials-blobclient"

}

variable "sufix_function_app_name" {
  description = "Nome da Azure Function App"
  type        = string
  default     = "fa-blobclient"
}

variable "sufix_frontend_app_name" {
  description = "Nome do Azure App Service para o frontend"
  type        = string
  default     = "as-blobclient"
}

variable "sufix_app_service_plan_name_backend" {
  description = "Nome do plano de serviço do App Service para a Azure Function App"
  type        = string
  default     = "asp-blobclient-backend"
}

variable "sufix_app_service_plan_name_frontend" {
  description = "Nome do plano de serviço do App Service"
  type        = string
  default     = "asp-blobclient-frontend"
}

variable "sufix_azure_credential_name" {
  description = "Nome da credencial do Azure"
  type        = string
  default     = "AZURE_CREDENTIALS"
}

variable "sufix_azuread_application_name" {
  description = "Nome do Azure AD Application"
  type        = string
  default     = "aad-sp-blobclient"
}

variable "sufix_azuread_service_principal_name" {
  description = "Nome do Azure AD Service Principal"
  type        = string
  default     = "aad-sp-blobclient"
}

variable "sufix_azuread_service_principal_password_name" {
  description = "Nome da senha do Azure AD Service Principal"
  type        = string
  default     = "aad-sp-password-blobclient"
}

variable "sufix_github_tf_workspace_name" {
  description = "Nome do workspace do GitHub para o Terraform"
  type        = string
  default     = "TF_WORKSPACE"
}

variable "sufix_github_storage_account_key" {
  description = "Nome do segredo do GitHub para a chave de acesso ao Storage Account"
  type        = string
  default     = "STORAGE_ACCOUNT_KEY"
}

variable "sufix_github_key_vault_uri" {
  description = "Nome do segredo do GitHub para o URI do Key Vault"
  type        = string
  default     = "KEY_VAULT_URI"
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true  
}

variable "github_owner" {
  description = "GitHub Repository Owner"
  type        = string  
}

variable "github_repository" {
  description = "GitHub Repository Name"
  type        = string
  default     = "BlobClient.Terraform"
}
