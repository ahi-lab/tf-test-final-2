#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

terraform {
  required_version = ">= 1.4.6"
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.54.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
}

resource "random_pet" "aksrandom" {
  
}
