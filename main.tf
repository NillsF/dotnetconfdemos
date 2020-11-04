terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

variable "admin_username" {
  type            = string
  description = "Administrator user name for virtual machine"
}

variable "admin_password" {
  type            = string
  description = "Password must meet Azure complexity requirements"
}

variable "client_secret" {
    type = string
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_sql_server" "cmsqlserver" {
  name                                         = "cmdotnetconfsqlsrv"
  resource_group_name              = var.resource_group_name
  location                                     = var.location
  version                                      = "12.0"
  administrator_login                  = var.admin_username
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "test" {
  name           = "cmdotnetconfsqldb"
  server_id      = azurerm_sql_server.cmsqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "BC_Gen5_2"
  zone_redundant = true
}
