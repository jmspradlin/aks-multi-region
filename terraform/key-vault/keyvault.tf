data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg_info" {
  name = var.rg_name
}

# Key Vault Resource builds
resource "azurerm_key_vault" "kv" {
  name                = var.kv_name
  location            = data.azurerm_resource_group.rg_info.location
  resource_group_name = data.azurerm_resource_group.rg_info.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = lower(var.kv_sku)

  enabled_for_disk_encryption     = var.kv_enabled_for_disk_encryption
  enabled_for_deployment          = var.kv_enabled_for_deployment
  enabled_for_template_deployment = var.kv_enabled_for_template_deployment
}

resource "azurerm_key_vault_secret" "kv_secret" {
  for_each     = var.kv_secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_access_policy.self
  ]
}

resource "azurerm_key_vault_access_policy" "self" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
    "recover",
    "backup",
    "restore",
    "Purge",
  ]
}

resource "azurerm_key_vault_access_policy" "dynamic" {
  for_each                = var.kv_access_policies
  key_vault_id            = azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = lookup(each.value, "object_id")
  key_permissions         = lookup(each.value, "key_permissions")
  secret_permissions      = lookup(each.value, "secret_permissions")
  certificate_permissions = lookup(each.value, "certificate_permissions")
}