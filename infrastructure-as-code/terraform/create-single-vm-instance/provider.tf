terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.9.0"
    }
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.71.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "azurerm" {
    features {}
}