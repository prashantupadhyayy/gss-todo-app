locals {
  base_name = lower(var.project) # "gss-app-infra"
  tags      = merge(var.tags, { environment = var.env, project = var.project })

  # names
  rg_name   = "${upper(replace(local.base_name, "-", " "))}-${upper(var.env)}-RG"
  mi_name   = "${local.base_name}-${var.env}-mi"
  kv_base   = substr(replace(local.base_name, "-", ""), 0, 20)
  kv_name   = "${local.kv_base}${var.env}kv"
  sa_prefix = substr("${replace(local.base_name, "-", "")}${var.env}", 0, 18)

  sql_server_name = "${local.base_name}-${var.env}-sql"
  sql_db_name     = "${local.base_name}-${var.env}-db"

  # NEW:
  acr_name = substr("${replace(local.base_name, "-", "")}${var.env}acr", 0, 50)

  aks_name   = "${local.base_name}-${var.env}-aks"
  dns_prefix = replace("${local.base_name}-${var.env}", "_", "-")

  # billable gate
  create_billable = var.enforce_free ? false : true
}

# --- Free resources ---
module "rg" {
  source   = "../../Modules/azurerm__Resource_group"
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

module "uai" {
  source              = "../../Modules/azurerm_managed_identity"
  name                = local.mi_name
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

# --- Billable resources (only when enforce_free=false) ---
module "kv" {
  source                     = "../../Modules/azurerm_key_vault"
  count                      = local.create_billable ? 1 : 0
  name                       = local.kv_name
  location                   = var.location
  resource_group_name        = module.rg.name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  access_policies = {
    mi = {
      object_id               = module.uai.principal_id
      key_permissions         = []
      secret_permissions      = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
      certificate_permissions = []
      storage_permissions     = []
    }
  }
  tags = local.tags
}

module "sa" {
  source                   = "../../Modules/azurerm_storage_account"
  count                    = local.create_billable ? 1 : 0
  name_prefix              = local.sa_prefix
  resource_group_name      = module.rg.name
  location                 = var.location
  allow_blob_public_access = false
  tags                     = local.tags
}

module "sql_server" {
  source                        = "../../Modules/azurerm_sql_server"
  count                         = local.create_billable ? 1 : 0
  name                          = local.sql_server_name
  resource_group_name           = module.rg.name
  location                      = var.location
  administrator_login           = var.sql_admin_login
  administrator_password        = var.sql_admin_password
  public_network_access_enabled = true
  minimum_tls_version           = "1.2"
  tags                          = local.tags
}

module "sql_db" {
  source    = "../../Modules/azurerm_sql_database"
  count     = local.create_billable ? 1 : 0
  name      = local.sql_db_name
  server_id = local.create_billable ? module.sql_server[0].id : ""
  sku_name  = "Basic"
  tags      = local.tags
}

# ------- NEW: ACR -------
module "acr" {
  source              = "../../Modules/azurerm_container_registry"
  count               = local.create_billable ? 1 : 0
  name                = local.acr_name
  resource_group_name = module.rg.name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin
  tags                = local.tags
}

# ------- NEW: AKS -------
module "aks" {
  source              = "../../Modules/azurerm_kubernetes_cluster"
  count               = local.create_billable ? 1 : 0
  name                = local.aks_name
  resource_group_name = module.rg.name
  location            = var.location
  dns_prefix          = local.dns_prefix
  kubernetes_version  = var.k8s_version
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  tags                = local.tags
}

# Give AKS permission to pull from ACR (only when both exist)
resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = local.create_billable ? 1 : 0
  scope                = module.acr[0].id
  role_definition_name = "AcrPull"
  principal_id         = module.aks[0].kubelet_object_id
}

# ------------- outputs -------------
output "resource_group" { value = module.rg.name }
output "managed_identity_id" { value = module.uai.id }
output "key_vault_name" { value = try(module.kv[0].name, null) }
output "storage_account" { value = try(module.sa[0].name, null) }
output "sql_server_name" { value = try(module.sql_server[0].name, null) }
output "sql_database_name" { value = try(module.sql_db[0].name, null) }
output "acr_name" { value = try(module.acr[0].name, null) }
output "aks_name" { value = try(module.aks[0].name, null) }
output "aks_kubeconfig" {
  value     = try(module.aks[0].kube_config_raw, null)
  sensitive = true
}

