variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "locations" {
  type        = map
  description = "Map of locations for app services and plans"
  default = {
    # eastus = {
    #   rg_location    = "eastus"
    #   address_space  = "192.168.0.0/24"
    #   node_pool_name = "ltleus"
    #   availability_zones = ["1", "2", "3"]
    # },
    # eastus2 = {
    #   rg_location = "eastus2"
    #   address_space  = "192.168.1.0/24"
    #   node_pool_name = "ltleus2"
    #   availability_zones = ["1", "2", "3"]
    # },
    # westus = {
    #   rg_location    = "westus"
    #   address_space  = "192.168.2.0/24"
    #   node_pool_name = "ltlwus"
    # },
    # westus2 = {
    #   rg_location = "westus2"
    #    address_space  = "192.168.3.0/24"
    #    node_pool_name = "ltlwus2"
    #    availability_zones = ["1", "2", "3"]
    # },
    southcentralus = {
      rg_location = "southcentralus"
      address_space  = "192.168.3.0/24"
      node_pool_name = "ltlscus"
      availability_zones = ["1", "2", "3"]
    },
    northcentralus = {
      rg_location = "northcentralus"
      address_space  = "192.168.4.0/24"
      node_pool_name = "ltlncus"
    }
  }
}

#variable "subscription_id" {}
#variable "tenant_id" {}
#variable "client_id" {}
#variable "client_secret" {}

variable "kv_access_policy" {
  type = list(object(
    {
      object_id               = string
      key_permissions         = list(string)
      secret_permissions      = list(string)
      certificate_permissions = list(string)
  }))
  default = []
}
#variable "kv_rg" {}
#variable "kv_name" {}

variable "subnets" {
  type = any
  default = {
    default01 = {
      address_prefixes  = ["192.168.0.0/24"]
      service_endpoints = ["Microsoft.KeyVault"]
      delegations = {
        delegation01 = {
          service_delegation_name = "Microsoft.ContainerInstance/containerGroups"
          actions                 = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }
  }
}