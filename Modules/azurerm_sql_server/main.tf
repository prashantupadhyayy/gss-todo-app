resource "azurerm_mssql_server" "sql" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_password
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags
}

output "id" { value = azurerm_mssql_server.sql.id }
output "name" { value = azurerm_mssql_server.sql.name }
