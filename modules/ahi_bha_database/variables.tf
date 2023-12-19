#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

variable "subscription_id" {
    type        = string
    description = "Azure subscription ID"
}

variable "client_id" {
    type        = string
    description = "Azure client ID"
}

variable "client_secret" {
    type        = string
    description = "Azure client secret"
}

variable "tenant_id" {
    type        = string
    description = "Azure tenant ID"
}

variable "az_rg_name" {
    type        = string
    description = "The Azure region group"
}

variable "az_rg_location" {
    type        = string
    description = "The Azure region group location"
}

variable "vendor" {
    type        = string
    description = "Partner's company name using the AHI technology, such as 'ACME'"
}

variable "app" {
    type        = string
    description = "App name"
    default     = "app"
}
