terraform {
  backend "azurerm" {
    resource_group_name  = "883144059-rg"
    storage_account_name = "883144059tfstate"
    container_name       = "tfstate"
    key                  = "nonprod.aks-multi-region.tfstate"
  }
}

provider azurerm {

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  # context
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  skip_provider_registration = true
}

# Multiple RG deployment
resource "azurerm_resource_group" "rg" {
  for_each = var.locations

  name     = "${each.value.rg_location}-rg01"
  location = each.value.rg_location
}

# Multiple Vnet deployment
module "virtual_network" {
  source   = "./vnet"
  for_each = var.locations
  depends_on = [
    azurerm_resource_group.rg
  ]
  rg_name       = "${each.value.rg_location}-rg01"
  vnet_name     = "vnet-${each.value.rg_location}-01"
  address_space = each.value.address_space
  subnet_name   = "default01"
}

# Multiple Log Analytics Deployment
module "log_analytics" {
  source   = "./log-analytics"
  for_each = var.locations
  depends_on = [
    azurerm_resource_group.rg
  ]
  rg_name      = "${each.value.rg_location}-rg01"
  la_name      = "loganalytics-${each.value.rg_location}-01"
  la_sku       = "Standard"
  la_retention = "30"
}

# Multiple AKS cluster deployment
module "aks_cluster" {
  source   = "./kubernetes"
  for_each = var.locations
  depends_on = [
    azurerm_resource_group.rg,
    module.log_analytics,
    module.virtual_network
  ]

  # RG variables
  rg_name = "${each.value.rg_location}-rg01"

  # Network variables
  vnet_name   = "vnet-${each.value.rg_location}-01"
  subnet_name = "default01"

  # Log Analytics variables
  la_workspace_name = "loganalytics-${each.value.rg_location}-01"

  # AKS variables
  aks_name               = "aks-ltl-${each.value.rg_location}-01"
  aks_dns_prefix_private = "aksltl${each.value.rg_location}"
  aks_identity_type      = "SystemAssigned"
  aks_node_pool_name     = each.value.node_pool_name
  aks_node_pool_vmsize   = "Standard_D2_v2"
  aks_autoscale_enable   = true
  aks_node_max_count     = 6
  aks_node_min_count     = 2
  aks_node_initial_count = 2
  aks_network_plugin     = "azure"
  aks_network_policy     = "calico"
  aks_lb_sku             = "Standard"
  aks_aad_managed        = true
  aks_rbac_enabled       = true
}