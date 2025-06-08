variable "subscription_id" {
  description = "ID da assinatura do Azure"
  type        = string
  default     = "bfce7383-81ce-4411-9bb6-4391c6f04c23"

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
variable "sufix_key_vault_secret_name" {
  description = "Nome do segredo no Key Vault para a chave de acesso ao Blob"
  type        = string
  default     = "kvs-blobclient"

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