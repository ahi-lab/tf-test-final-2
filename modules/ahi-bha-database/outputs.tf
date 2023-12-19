#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

output "cosmosdb_account_endpoint" {
   value = base64encode(azurerm_cosmosdb_account.cosmosdb_account.endpoint )
}

output "cosmosdb_db_name" {
   value = base64encode(azurerm_cosmosdb_sql_database.cosmodb.name)
}

output "cosmosdb_primary_master_key" {
   # value = nonsensitive(azurerm_cosmosdb_account.cosmosdb_account.primary_master_key)

   value = base64encode(azurerm_cosmosdb_account.cosmosdb_account.primary_key)
}

output "cosmosdb_connectionstrings" {
   value = "AccountEndpoint=${azurerm_cosmosdb_account.cosmosdb_account.endpoint};AccountKey=${azurerm_cosmosdb_account.cosmosdb_account.primary_key};"
   sensitive   = true
}
