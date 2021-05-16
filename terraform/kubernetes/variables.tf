variable "rg_name" {}

variable "vnet_name" {}
variable "subnet_name" {}

variable "la_workspace_name" {}

variable "aks_name" {}
variable "aks_dns_prefix_private" {}
variable "aks_identity_type" {}
variable "aks_node_pool_name" {}
variable "aks_node_pool_vmsize" {}
variable "aks_autoscale_enable" {}
variable "aks_node_availability_zones" {}
variable "aks_node_max_count" {}
variable "aks_node_min_count" {}
variable "aks_node_initial_count" {}
variable "aks_network_plugin" {}
variable "aks_network_policy" {}
variable "aks_lb_sku" {}
variable "aks_aad_managed" {}
variable "aks_rbac_enabled" {}