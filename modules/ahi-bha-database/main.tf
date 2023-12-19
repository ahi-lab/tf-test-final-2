#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

locals {
  cosmosdb_account_name = try(random_string.db_account_name[0].result, var.cosmosdb_account_name)
}

resource "random_string" "db_account_name" {
  count = var.cosmosdb_account_name == null ? 1 : 0

  length  = 20
  upper   = false
  special = false
  numeric = false
}

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                      = local.cosmosdb_account_name
  location                  = var.region
  resource_group_name       = var.cosmosdb_resource_group_name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  geo_location {
    location          = var.region
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmodb" {
  name                = var.cosmosdb_db_name
  resource_group_name = var.cosmosdb_resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  autoscale_settings {
    max_throughput = var.max_throughput
  }
}