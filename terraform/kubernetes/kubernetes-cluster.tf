data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_log_analytics_workspace" "la01" {
  name                = var.la_workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  workspace_resource_id = data.azurerm_log_analytics_workspace.la01.id
  workspace_name        = var.la_workspace_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.rg.location
  dns_prefix          = var.aks_dns_prefix_private
  resource_group_name = data.azurerm_resource_group.rg.name


  identity {
    type = var.aks_identity_type
  }
  default_node_pool {
    name                = var.aks_node_pool_name
    vm_size             = var.aks_node_pool_vmsize
    vnet_subnet_id      = data.azurerm_subnet.subnet.id
    enable_auto_scaling = var.aks_autoscale_enable
    availability_zones  = var.aks_node_availability_zones
    max_count           = var.aks_node_max_count
    min_count           = var.aks_node_min_count
    node_count          = var.aks_node_initial_count
  }
  network_profile {
    network_plugin    = var.aks_network_plugin
    network_policy    = var.aks_network_policy
    load_balancer_sku = var.aks_lb_sku
  }

  addon_profile {
    oms_agent {
      enabled                    = "true"
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.la01.id
    }
  }
}  