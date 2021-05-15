output "id" {
  value       = azurerm_virtual_network.vnet.id
}

output "name" {
  value       = azurerm_virtual_network.vnet.name
}

output "location" {
  value       = azurerm_virtual_network.vnet.location
}

output "address_space" {
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
}