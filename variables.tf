#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

variable "subscription_id" {
    type        = string
    description = "Azure subscription ID"
    # default = "2e122491-605d-45a5-bd79-746e4648dc58"
}

variable "tenant_id" {
    type        = string
    description = "Azure tenant ID"
    # default = "b5c6e60e-a9f4-4db7-a563-ea4b5f361c00"
}

variable "client_id" {
    type        = string
    description = "Azure client ID"
    # default = "1843a40b-f10a-485d-a18f-1da4a11dac58"
}

variable "client_secret" {
    type        = string
    description = "Azure client secret"
    # default = "Ise8Q~GMzWB-hlFgMqtKMwzojyQ6SePaOOl8Xcxd"
}

variable "az_dns_zone_name" {
    type        = string
    description = "Public DNS zone name."
    # default     = "az1-ahi.com"
}

variable "az_dns_zone_resource_group_name" {
    type        = string
    description = "Resource group name for the public DNS zone."
    default     = "dns-zone"
}

variable "region" {
    type        = string
    description = "(Optional) The Azure location/region to deploy to, such as 'Australia East'."
    default     = "Australia East"
}

# variable "vendor" {
#     type        = string
#     description = "Client's name, such as 'ACME'."
# }

variable "app" {
    type        = string
    description = "Client's app name. Default 'app'."
    default     = "bha"
}

variable "cloud_infra_source" {
    type        = string
    description = "Source for the cloud infrastructure."
    default     = "../modules/cloud-infra"
}

variable "environment" {
    type        = string
    description = "Environment of the infrastructure."
    default     = "dev"
}

variable "ssh_public_key" {
    type        = string
    description = "SSH public key for authentication."
    default     = "aks-internal-sshkey.pub"
}

variable "aks_dns_service_ip" {
    type        = string
    description = "AKS DNS service IP."
    default     = "10.100.240.10"
}

variable "aks_service_cidr" {
    type        = string
    description = "AKS service CIDR."
    default     = "10.100.240.0/20"
}

variable "aks_vnet_address_space" {
    type        = string
    description = "AKS virtual network address space."
    default     = "10.100.0.0/16"
}

variable "aks_subnet_default_address_space" {
    type        = string
    description = "AKS subnet default address space."
    default     = "10.100.0.0/20"
}

variable "aks_subnet_api_address_space" {
    type        = string
    description = "AKS subnet API address space."
    default     = "10.100.16.0/20"
}

variable "aks_subnet_dbcluster_address_space" {
    type        = string
    description = "AKS subnet database cluster address space."
    default     = "10.100.32.0/20"
}

variable "aks_subnet_virtual_nodes_address_space" {
    type        = string
    description = "AKS subnet virtual nodes address space."
    default     = "10.100.48.0/20"
}

variable "aks_k8s_version" {
    type        = string
    description = "AKS Kubernetes version."
    default     = "1.26.6"
}

variable "aks_cluster_issuer_sp_name" {
    type        = string
    description = "AKS cluster issuer service principal name."
    default     = "aks_ci_sp_bha_dev"
}

variable "k8s_infra_source" {
    type        = string
    description = "Source for the k8s infrastructure."
    default     = "../modules/k8s-infra"
}

variable "aks_grafana_admin_user" {
    type        = string
    description = "Admin user for Grafana."
    default     = "admin"
}

variable "aks_grafana_admin_password" {
    type        = string
    description = "Admin password for Grafana."
    default     = "p@sSw0rd$1%-#1"
}

variable "metrics_dashboard_host_prefix" {
    type        = string
    description = "Host prefix for metrics dashboard."
    default     = "dashboard"
}


# Variables for BHA Service
variable "bha_service_namespace" {
  type        = string  
  default     = "bha-service"    
}

variable "ahi_apigw_image" {
  type        = string
  default = "samuelest/apigw:1.14"
}

variable "ahi_apigw_ingress_host_prefix" {
  type        = string  
  default = "api"
}

variable "ahi_eureka_image" {
  type        = string  
  default = "samuelest/eureka-server:1.14"
}

variable "ahi_pactbroker_ingress_host_prefix" {
  type        = string
  default = "pact"
}

variable "ahi_api_image" {
  type        = string  
  default = "samuelest/bha-backend-api:1.14"
}