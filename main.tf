terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.12"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "westus2"
  tags = {
     Environment = "Terraform Getting Started"
     Team = "DevOps"
   }
}

resource "azurerm_storage_account" "storacc" {
  name                     = "annanstoracc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "annancontainer"
  storage_account_name  = azurerm_storage_account.storacc.name
  container_access_type = "private"
}


resource "azurerm_virtual_network" "vnet" {
    name                = "annanTFVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westus2"
    resource_group_name = azurerm_resource_group.rg.name
} 

resource "azurerm_subnet" "sub" {
  name                 = "annansubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}