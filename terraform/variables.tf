variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "locations" {
  type        = map
  description = "Map of locations for app services and plans"
  default = {
    eastus = {
      rg_location    = "eastus"
      address_space  = "192.168.0.0/24"
      node_pool_name = "ltleus"
    },
    # eastus2 = {
    #   rg_location = "eastus2"
    # },
    westus = {
      rg_location    = "westus"
      address_space  = "192.168.1.0/24"
      node_pool_name = "ltlwus"
    },
    # westus2 = {
    #   rg_location = "westus2"
    # },
    # southcentralus = {
    #   rg_location = "southcentralus"
    # },
    # northcentralus = {
    #   rg_location = "northcentralus"
    # }
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