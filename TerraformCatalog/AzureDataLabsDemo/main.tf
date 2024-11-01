terraform {
  # backend "azurerm" {}
  required_providers {
    azurerm = {
      version = "= 3.45.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}
