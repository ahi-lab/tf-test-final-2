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

	  kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }

  }

  # Terraform State Storage to Azure Storage Container
  # backend "azurerm" {
  #   resource_group_name = "terraform-storage-rg"
  #   storage_account_name = "terraformstateahienv"
  #   container_name = "tfstatefiles"
  #   key = "terraform-cloud-infra-bha.tfstate"
  # }

  #   backend "azurerm" {
  #   resource_group_name = "ahi-poc-temp"
  #   storage_account_name = "terraformstatetestenv"
  #   container_name = "tfstatefiles"
  #   key = "terraform-ahi-cloud-bha-dev.tfstate"
  # }
}

