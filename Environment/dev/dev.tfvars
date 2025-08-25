project  = "gss-app-infra"
env      = "dev"
location = "East US"
tags     = { owner = "GSS", costcenter = "1001" }

# keep FREE
enforce_free = true

# if you later turn free off:
acr_sku        = "Basic"
acr_admin      = false
aks_node_count = 1
aks_vm_size    = "Standard_B2s"
k8s_version    = null
