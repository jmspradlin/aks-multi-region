data "azurerm_resource_group" "rg_info" {
  name = var.rg_name
}

resource "azurerm_log_analytics_workspace" "log_analytics01" {
  name                = var.la_name
  location            = data.azurerm_resource_group.rg_info.location
  resource_group_name = data.azurerm_resource_group.rg_info.name
  sku                 = var.la_sku
  retention_in_days   = var.la_retention
}