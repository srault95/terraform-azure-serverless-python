data "azurerm_resource_group" "rg" {
  name = var.app_rg_name
}

resource "azurerm_storage_account" "storage" {
  name                     = var.app_storage_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_app_service_plan" "plan" {
  name                = var.app_plan_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = var.app_plan_sku["tier"]
    size = var.app_plan_sku["size"]
  }

  # Pour éviter le "kind = "linux" -> "FunctionApp" # forces replacement lors d'une mise à jour
  lifecycle {
    ignore_changes = [
      kind,
    ]
  }


}

# resource "azurerm_application_insights" "insights" {
#   name                = var.app_insights_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   application_type    = "web"
#   retention_in_days   = 30
# }

resource "azurerm_function_app" "func" {
  name                       = var.app_function_name
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  os_type                    = "linux"
  version                    = "~3"
  https_only                  = true

  app_settings = {
    AzureWebJobsStorage            = azurerm_storage_account.storage.primary_connection_string
    AzureWebJobsDashboard          = azurerm_storage_account.storage.primary_connection_string
    #APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    ENABLE_ORYX_BUILD              = "true"
    BUILD_FLAGS                    = "UseExpressBuild"
    FUNCTIONS_EXTENSION_VERSION    = "~3"
    FUNCTIONS_WORKER_RUNTIME       = "python"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "1"
    XDG_CACHE_HOME                 = "/tmp/.cache"
  }

  site_config {
    linux_fx_version          = "PYTHON|3.8"
    use_32_bit_worker_process = false
    scm_type                  = "None"
    ftps_state                = "Disabled"
  }

  depends_on = [
    azurerm_app_service_plan.plan
  ]

}


