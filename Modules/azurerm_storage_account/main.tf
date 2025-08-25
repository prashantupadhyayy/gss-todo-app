resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  cleaned_prefix = lower(replace(var.name_prefix, "[^a-z0-9]", ""))
  sa_name        = substr("${local.cleaned_prefix}${random_string.suffix.result}", 0, 24)
}

resource "azurerm_storage_account" "sa" {
  name                            = local.sa_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.replication_type
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
}

output "name" {
  value = azurerm_storage_account.sa.name
}

output "id" {
  value = azurerm_storage_account.sa.id
}
