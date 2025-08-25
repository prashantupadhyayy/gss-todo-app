variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "purge_protection_enabled" {
  type    = bool
  default = true
}

variable "access_policies" {
  type = map(object({
    object_id              = string
    secret_permissions     = list(string)
    key_permissions        = list(string)
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
