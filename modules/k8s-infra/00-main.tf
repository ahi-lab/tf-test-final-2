#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

terraform {
  # backend "azurerm" {
  #   resource_group_name = "terraform-storage-rg"
  #   storage_account_name = "terraformstateahienv"
  #   container_name = "tfstatefiles"
  #   key = "terraform-k8s-infra.tfstate"
  # }

  required_providers {
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
}