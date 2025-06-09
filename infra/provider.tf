terraform {
  required_version = ">= 1.3.0"
  required_providers {
    # Provedor para integração com o Azure
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }

    # Provedor para integração com o AzureAD
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }

    # Provedor para integração com o GitHub
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Configurações adicionais do provedor podem ser adicionadas aqui
  subscription_id = var.subscription_id
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}