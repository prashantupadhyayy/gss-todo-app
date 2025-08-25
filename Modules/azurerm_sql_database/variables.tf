variable "name" {
  type = string
}

variable "server_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "GP_S_Gen5_2"
}

variable "max_size_gb" {
  type    = number
  default = 32
}

variable "collation" {
  type    = string
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "tags" {
  type    = map(string)
  default = {}
}
