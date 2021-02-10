variable "app_rg_name" {
  type        = string
  description = "Resource Group Name for APP"
}

variable "app_storage_name" {
  type        = string
  description = "Storage Name for APP"
}

variable "app_plan_name" {
  type        = string
  description = "App Plan Name for APP"
}

variable "app_plan_sku" {
  type        = map(string)
  description = "App Plan Sku for APP"

  default = {
    tier = "Dynamic"
    size = "Y1"
  }
}

variable "app_insights_name" {
  type        = string
  description = "App Insight Name"
}

variable "app_function_name" {
  type        = string
  description = "App Function Name for APP"
}

