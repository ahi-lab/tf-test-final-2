#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

# variable "subscription_id" {
#     type        = string
#     description = "Azure subscription ID"
# }

# variable "client_id" {
#     type        = string
#     description = "Azure client ID"
# }

# variable "client_secret" {
#     type        = string
#     description = "Azure client secret"
# }

# variable "tenant_id" {
#     type        = string
#     description = "Azure tenant ID"
# }

variable "region" {
    type        = string
    description = "The Azure region group location"
    default     = "Australia East"
}

# variable "vendor" {
#     type        = string
#     description = "Partner's company name using the AHI technology, such as 'ACME'"
# }

# variable "app" {
#     type        = string
#     description = "App name"
#     default     = "app"
# }

variable "cosmosdb_resource_group_name" {
    type = string
    description = "CosmosDB resource group name"
    default     = "cosmodb-rg"  
}

variable "cosmosdb_db_name" {
    type = string
    description = "CosmosDB datatbase name"
    default     = "cosmosdb"
}

variable "cosmosdb_account_name" {
  type        = string
  # default     = "ahi-bha-cosmos-account"
  default     = null
  description = "Cosmos db account name"
}

variable "max_throughput" {
  type        = number
  default     = 4000
  description = "Cosmos db database max throughput"
  validation {
    condition     = var.max_throughput >= 4000 && var.max_throughput <= 1000000
    error_message = "Cosmos db autoscale max throughput should be equal to or greater than 4000 and less than or equal to 1000000."
  }
  validation {
    condition     = var.max_throughput % 100 == 0
    error_message = "Cosmos db max throughput should be in increments of 100."
  }
}