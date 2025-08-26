resource "azurerm_mssql_database" "db" {
  name           = var.name
  server_id      = var.server_id
  sku_name       = var.sku_name
  max_size_gb    = var.max_size_gb
  collation      = var.collation
  zone_redundant = false
  tags           = var.tags
}

output "id" { value = azurerm_mssql_database.db.id }
output "name" { value = azurerm_mssql_database.db.name }
