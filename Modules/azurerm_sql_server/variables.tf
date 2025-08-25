variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "administrator_password" {
  type      = string
  sensitive = true
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "minimum_tls_version" {
  type    = string
  default = "1.2"
}

variable "tags" {
  type    = map(string)
  default = {}
}
