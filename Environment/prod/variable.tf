variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# kept for when you disable enforce_free
variable "sql_admin_login" {
  type    = string
  default = "sqladmin"
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
  default   = "TempP@ssword-DoNotUse"
}

variable "tenant_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

# hard gate to avoid paid resources
variable "enforce_free" {
  type    = bool
  default = true
}

# ACR
variable "acr_sku" {
  type    = string
  default = "Basic"
}

variable "acr_admin" {
  type    = bool
  default = false
}

# AKS
variable "aks_node_count" {
  type    = number
  default = 1
}

variable "aks_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "k8s_version" {
  type    = string
  default = null
}
