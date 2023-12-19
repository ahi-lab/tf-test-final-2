#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

variable "location" {
    default = "Australia East"
    description = "This will be the location where all the resources created"  
    type = string
}

variable "app" {
    type = string
    description = "This is the variable that define the Application"
    default = "bha"
}

variable "environment" {
    type = string
    description = "This is the variable that define the Environmen"
    default = "poc"
}

variable "resource_group_name_cluster_prefix" {
    type = string
    description = "this is the resource group name prefix for aks cluster"
    default = "aks"
}

variable "aks_k8s_version" {
    type = string
    description = "kubernetes version that will be installed. "
    default = "1.25.6"
}

variable "windows_admin_username" {
    type = string
    description = "this is the windows admin username"
    default = "azureuser"
}

variable "windows_admin_password" {
    type = string
    description = "this is the windows admin password"
    default = "P@ssw0rd4AH1De#"
}

variable "linux_admin_username" {
    type = string
    description = "this is the windows admin username"
    default = "azureuser"
}

variable "ssh_public_key" {
    type = string
    description = "this is sskey"
    default = "aks-poc-sshkey.pub"
}

variable "aks_dns_service_ip" {
    type = string
    description = "This is dns service ip"
    default = "10.0.240.10"
}

variable "aks_service_cidr" {
    type = string
    description = "This is service cidr"
    default = "10.0.240.0/20"
}

variable "aks_vnet_address_space" {
    type = string
    description = "This is AKs vnet address space"
    default = "10.0.0.0/16"
}

variable "aks_subnet_default_address_space" {
    type = string
    description = "This is AKs subnet default address space"
    default = "10.0.0.0/20"
}

variable "aks_subnet_api_address_space" {
    type = string
    description = "This is AKs subnet api address space"
    default = "10.0.16.0/20"
}

variable "aks_subnet_dbcluster_address_space" {
    type = string
    description = "This is AKs subnet database cluster address space"
    default = "10.0.32.0/20"
}

variable "aks_subnet_virtual_nodes_address_space" {
    type = string
    description = "This is AKs subnet virtual nodes address space"
    default = "10.0.48.0/20"
}

variable "aks_cluster_issuer_sp_name" {
    type = string
    description = "This is AKs subnet virtual nodes address space"
    default = "aks_cluster_issuer_service_principal"
}

variable "az_dns_zone_resource_group_name" {
    type = string
    description = "This is DNS Zone Resource Group Name"
    default = "dns-zone"
}

variable "az_dns_zone_name" {
    type = string
    description = "This is DNS Zone Name"
    default = "az1-ahi.com"
}

variable "az_dns_zone_role_assign" {
    type = string
    description = "This is DNS Zone role assign"
    default = "DNS Zone Contributor"
}

# Service Principal client ID for terraform execution
# the Service Principal will be added to the newly created Group to 'manage' Kubernetes cluster
# In this case, the Service Principal can deploy microservices and basic components
variable "tf_sp_client_id" {
    type        = string
    description = "service principal client ID for terraform execution"
}
