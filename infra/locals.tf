locals {
  workspace_formatted = lower(substr(terraform.workspace, 0, 4))
  workspace_name      = local.workspace_formatted == "deve" ? substr(local.workspace_formatted, 0, 3) : local.workspace_formatted

  resource_group_name                     = "${local.workspace_name}-${var.sufix_resource_group_name}"
  storage_account_name                    = "${local.workspace_name}${var.sufix_storage_account_name}"
  key_vault_name                          = "${local.workspace_name}-${var.sufix_key_vault_name}"
  key_vault_secret_storage_name           = "${local.workspace_name}-${var.sufix_key_vault_secret_storage_name}"
  key_vault_secret_azcredentials_name     = "${local.workspace_name}-${var.sufix_key_vault_secret_azcredentials_name}"
  app_service_plan_name_backend           = "${local.workspace_name}-${var.sufix_app_service_plan_name_backend}"
  app_service_plan_name_frontend          = "${local.workspace_name}-${var.sufix_app_service_plan_name_frontend}"
  function_app_name                       = "${local.workspace_name}-${var.sufix_function_app_name}"
  frontend_app_name                       = "${local.workspace_name}-${var.sufix_frontend_app_name}"
  azure_credential_name                   = "${var.sufix_azure_credential_name}_${upper(local.workspace_name)}"
  azuread_application_name                = "${local.workspace_name}-${var.sufix_azuread_application_name}"
  azuread_service_principal_name          = "${local.workspace_name}-${var.sufix_azuread_service_principal_name}"
  azuread_service_principal_password_name = "${local.workspace_name}-${var.sufix_azuread_service_principal_password_name}"
  github_tf_workspace_name                = "${var.sufix_github_tf_workspace_name}_${upper(local.workspace_name)}"
  github_storage_account_key              = "${var.sufix_github_storage_account_key}_${upper(local.workspace_name)}"
  github_key_vault_uri                    = "${var.sufix_github_key_vault_uri}_${upper(local.workspace_name)}" 
}