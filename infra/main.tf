# Configuração do Provedor Azure
data "azurerm_client_config" "current" {}

# Criação do grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

# Criação do Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = terraform.workspace
  }
}

# Criação do Key Vault
resource "azurerm_key_vault" "vault_blobclient" {
  name                       = local.key_vault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id # Ex: SP ou user que executa o terraform

    secret_permissions = [
      "Get",
      "Set",
      "Delete",
      "List",
    ]

    key_permissions = [
      "Get",
      "List",
    ]

    certificate_permissions = [
      "Get",
    ]
  }

  tags = {
    environment = terraform.workspace
  }
}

# Criação do segredo no Key Vault para armazenar a chave de acesso ao Blob
resource "azurerm_key_vault_secret" "blob_storage_key" {
  name         = local.key_vault_secret_storage_name
  value        = azurerm_storage_account.storage.primary_access_key # Substitua pela chave real ou outra variável
  key_vault_id = azurerm_key_vault.vault_blobclient.id

  tags = {
    environment = terraform.workspace
  }
}

# Criação do segredo no Key Vault para armazenar a chave de acesso ao Blob (para uso em GitHub Actions)
resource "azurerm_key_vault_secret" "azure_credentials_key" {
  name         = local.key_vault_secret_azcredentials_name
  value        = github_actions_secret.azure_credentials.plaintext_value
  key_vault_id = azurerm_key_vault.vault_blobclient.id

  tags = {
    environment = terraform.workspace
  }
}

# Criação do App Service Plan para o Frontend (ASP.NET Core MVC)
resource "azurerm_app_service_plan" "frontend_plan" {
  name                = local.app_service_plan_name_frontend
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true # Necessário para Linux

  sku {
    tier = "Free"
    size = "F1"
  }

  tags = {
    environment = terraform.workspace
  }
}

# Criação do Azure App Service para o Frontend (ASP.NET Core MVC)
resource "azurerm_linux_web_app" "frontend" {
  name                = local.frontend_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_app_service_plan.frontend_plan.id

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = terraform.workspace
    "AzureWebJobsStorage"    = azurerm_storage_account.storage.primary_connection_string
    "KeyVaultUri"            = azurerm_key_vault.vault_blobclient.vault_uri
  }

  site_config {
    application_stack {
      dotnet_version = "9.0" # especificando .NET 9
    }
    always_on = false
  }

  tags = {
    environment = terraform.workspace
  }
}

# Criação do App Service Plan para a Azure Function (Isolated)
resource "azurerm_app_service_plan" "backend_plan" {
  name                = local.app_service_plan_name_backend
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    environment = terraform.workspace
  }
}

# Criação da Azure Function App (Isolated .NET 9)
resource "azurerm_linux_function_app" "backend" {
  name                        = local.function_app_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  service_plan_id             = azurerm_app_service_plan.backend_plan.id
  storage_account_name        = azurerm_storage_account.storage.name
  storage_account_access_key  = azurerm_storage_account.storage.primary_access_key
  functions_extension_version = "~4"

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-Isolated"
    "DOTNET_FUNCTIONS_VERSION" = "9"
    "KeyVaultUri"              = azurerm_key_vault.vault_blobclient.vault_uri
  }

  site_config {
    application_stack {
      dotnet_version              = "9.0" # especificando .NET 9
      use_dotnet_isolated_runtime = true
    }
  }

  tags = {
    environment = terraform.workspace
  }
}

resource "azuread_application" "principal" {
  display_name = local.azuread_application_name
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "service_principal" {
  client_id = azuread_application.principal.client_id
  owners    = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal_password" "client_secret" {
  service_principal_id = azuread_service_principal.service_principal.id
  end_date             = "2099-12-31T23:59:59Z" # Defina uma data de expiração adequada
  display_name         = local.azuread_service_principal_password_name
}

# Create GitHub Actions secrets
resource "github_actions_secret" "azure_credentials" {
  repository  = var.github_repository
  secret_name = local.azure_credential_name
  plaintext_value = jsonencode({
    clientId       = data.azurerm_client_config.current.client_id
    clientSecret   = azuread_service_principal_password.client_secret.value
    objectId       = data.azurerm_client_config.current.object_id
    subscriptionId = var.subscription_id
    tenantId       = data.azurerm_client_config.current.tenant_id
  })
}

resource "github_actions_secret" "terraform_workspace" {
  repository      = var.github_repository
  secret_name     = local.github_tf_workspace_name
  plaintext_value = local.workspace_name
}

resource "github_actions_secret" "storage_account_key" {
  repository      = var.github_repository
  secret_name     = local.github_storage_account_key
  plaintext_value = azurerm_storage_account.storage.primary_access_key
}

resource "github_actions_secret" "key_vault_uri" {
  repository      = var.github_repository
  secret_name     = local.github_key_vault_uri
  plaintext_value = azurerm_key_vault.vault_blobclient.vault_uri
}
