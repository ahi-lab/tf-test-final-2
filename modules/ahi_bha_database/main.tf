#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}


################################################################################
# Create the CosmosDB database
################################################################################

# data "azurerm_cosmosdb_account" "ahi_bha_db_account" {
#   name                = "ahi-bha-${var.vendor}-${var.app}-cosmosdb-acc"
#   resource_group_name = var.az_rg_name
# }

# resource "azurerm_cosmosdb_sql_database" "ahi_bha_db_sql" {
#   name                = "ahi-bha-${var.vendor}-${var.app}-cosmosdb-sql"
#   resource_group_name = data.azurerm_cosmosdb_account.ahi_bha_db_account.resource_group_name
#   account_name        = data.azurerm_cosmosdb_account.ahi_bha_db_account.name
# }
