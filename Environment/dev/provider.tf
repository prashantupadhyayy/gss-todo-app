terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {}

  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.117" }
    random  = { source = "hashicorp/random",  version = "~> 3.7" }
  }
}

provider "azurerm" {
  features {}
}
