resource "azurerm_user_assigned_identity" "uai" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

output "id" { value = azurerm_user_assigned_identity.uai.id }
output "principal_id" { value = azurerm_user_assigned_identity.uai.principal_id }
output "client_id" { value = azurerm_user_assigned_identity.uai.client_id }
