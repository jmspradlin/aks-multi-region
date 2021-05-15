data "azurerm_resource_group" "rg_info" {
  name = var.rg_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.rg_info.location
  address_space       = [var.address_space]
  resource_group_name = data.azurerm_resource_group.rg_info.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg_info.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes  = [var.address_space]
}