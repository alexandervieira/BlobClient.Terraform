locals {
  workspace_formatted            = lower(substr(terraform.workspace, 0, 3))
  resource_group_name            = "${local.workspace_formatted}-${var.sufix_resource_group_name}"
  storage_account_name           = "${local.workspace_formatted}${var.sufix_storage_account_name}"
  key_vault_name                 = "${local.workspace_formatted}-${var.sufix_key_vault_name}"
  key_vault_secret_name          = "${local.workspace_formatted}-${var.sufix_key_vault_secret_name}"
  app_service_plan_name_backend  = "${local.workspace_formatted}-${var.sufix_app_service_plan_name_backend}"
  app_service_plan_name_frontend = "${local.workspace_formatted}-${var.sufix_app_service_plan_name_frontend}"
  function_app_name              = "${local.workspace_formatted}-${var.sufix_function_app_name}"
  frontend_app_name              = "${local.workspace_formatted}-${var.sufix_frontend_app_name}"
}