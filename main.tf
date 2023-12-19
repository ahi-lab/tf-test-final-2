#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

data "azurerm_kubernetes_cluster" "default" {
  depends_on          = [module.cloud-infra] # refresh cluster state before reading
  name                = module.cloud-infra.aks-cluster-name
  resource_group_name = module.cloud-infra.resource-group-name-cluster
}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

provider "azuread"{
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  use_cli         = "false"
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)

  # When run locally, enable this part. Using kubelogin to get an AAD token for the cluster.
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "kubelogin"
  #   args = [
  #     "get-token",
  #     "--environment",
  #     "AzurePublicCloud",
  #     "--server-id",
  #     "6dae42f8-4368-4678-94ff-3960e28e3630", # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
  #     "--client-id",
  #     var.client_id, # SPN App Id created via terraform
  #     "--client-secret",
  #     var.client_secret,
  #     "--tenant-id",
  #     var.tenant_id, # AAD Tenant Id
  #     "--login",
  #     "spn"
  #   ]
  # }  
}

provider "helm" {
  kubernetes {
      host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
      cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
      client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
      client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)

    # When run locally, enable this part. Using kubelogin to get an AAD token for the cluster.
    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   command     = "kubelogin"
    #   args = [
    #     "get-token",
    #     "--environment",
    #     "AzurePublicCloud",
    #     "--server-id",
    #     "6dae42f8-4368-4678-94ff-3960e28e3630", # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
    #     "--client-id",
    #     var.client_id, # SPN App Id created via terraform
    #     "--client-secret",
    #     var.client_secret,
    #     "--tenant-id",
    #     var.tenant_id, # AAD Tenant Id
    #     "--login",
    #     "spn"
    #   ]
    # }
  }
}


provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)

  load_config_file       = false


  # When run locally, enable this part. Using kubelogin to get an AAD token for the cluster.
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "kubelogin"
  #   args = [
  #     "get-token",
  #     "--environment",
  #     "AzurePublicCloud",
  #     "--server-id",
  #     "6dae42f8-4368-4678-94ff-3960e28e3630", # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
  #     "--client-id",
  #     var.client_id, # SPN App Id created via terraform
  #     "--client-secret",
  #     var.client_secret,
  #     "--tenant-id",
  #     var.tenant_id, # AAD Tenant Id
  #     "--login",
  #     "spn"
  #   ]
  # }

}


module "cloud-infra" {
  source = "./modules/cloud-infra"
  location = var.region
  app = var.app
  environment = var.environment
  ssh_public_key = var.ssh_public_key

  # network configurations
  aks_dns_service_ip = var.aks_dns_service_ip
  aks_service_cidr = var.aks_service_cidr
  aks_vnet_address_space = var.aks_vnet_address_space
  aks_subnet_default_address_space = var.aks_subnet_default_address_space
  aks_subnet_api_address_space = var.aks_subnet_api_address_space
  aks_subnet_dbcluster_address_space = var.aks_subnet_dbcluster_address_space
  aks_subnet_virtual_nodes_address_space = var.aks_subnet_virtual_nodes_address_space
  
  # kubernetes version
  aks_k8s_version = var.aks_k8s_version
  
  # public DNS Zone
  az_dns_zone_name = var.az_dns_zone_name
  
  # public DNS Zone
  az_dns_zone_resource_group_name = var.az_dns_zone_resource_group_name

  # Service Principal client ID for terraform execution
  # the Service Principal will be added to the newly created Group to 'manage' Kubernetes cluster
  # In this case, the Service Principal can deploy microservices and basic components    
  tf_sp_client_id = var.client_id
     
  # Different environment should have different name
  aks_cluster_issuer_sp_name = var.aks_cluster_issuer_sp_name
}

module "ahi-bha-database" {
  source = "./modules/ahi-bha-database"
  depends_on   = [module.cloud-infra]
  cosmosdb_resource_group_name = module.cloud-infra.resource-group-name-cluster
  region = var.region
}


module "k8s-infra" {
  source = "./modules/k8s-infra"

  depends_on   = [module.cloud-infra]
  kubeconfig   = data.azurerm_kubernetes_cluster.default.kube_config_raw
  # kubeconfig =  module.cloud-infra.kube_config

  cert_manager_ns_desc = module.cloud-infra.aks_app_cluster_issuer_object_id

  subscription_id =  var.subscription_id
  tenant_id = var.tenant_id

  # Different environment should have different DNS Zone
  # public DNS Zone
  az_dns_zone_name = var.az_dns_zone_name
  
  # public DNS Zone resource group
  az_dns_zone_rg_name = var.az_dns_zone_resource_group_name
  
  # Different environment should have different name
  aks_cluster_issuer_sp_name = var.aks_cluster_issuer_sp_name
    
  aks_cluster_name = module.cloud-infra.aks-cluster-name  
  
  aks_cluster_node_rg_name =  module.cloud-infra.node-resource-group

  aks_app_cluster_issuer_object_id = module.cloud-infra.aks_app_cluster_issuer_object_id

  aks_sp_cluster_issuer_password_sp_application_id = module.cloud-infra.aks_sp_cluster_issuer_password_sp_application_id
  azurerm_user_assigned_identity_client_id = module.cloud-infra.azurerm_user_assigned_identity_client_id
  ingress_public_ip_address = module.cloud-infra.ingress_public_ip_address
  
  aks_grafana_admin_user = var.aks_grafana_admin_user
  
  aks_grafana_admin_password = var.aks_grafana_admin_password  
  metrics_dashboard_host = "${var.metrics_dashboard_host_prefix}.${var.az_dns_zone_name}"
}


module "bha-services" {
  depends_on   = [module.k8s-infra, module.ahi-bha-database]
  source = "./modules/ahi-bha-services"
  bha_service_namespace       = var.bha_service_namespace
  ahi_apigw_image             = var.ahi_apigw_image
  ahi_apigw_ingress_host      = "${var.ahi_apigw_ingress_host_prefix}.${var.az_dns_zone_name}"
  ahi_eureka_image            = var.ahi_eureka_image
  ahi_pactbroker_ingress_host = "${var.ahi_pactbroker_ingress_host_prefix}.${var.az_dns_zone_name}"
  ahi_api_image               = var.ahi_api_image
  
  ahi_api_dataSource_database = module.ahi-bha-database.cosmosdb_db_name
  ahi_api_dataSource_uri      = module.ahi-bha-database.cosmosdb_account_endpoint
  ahi_api_dataSource_key      = module.ahi-bha-database.cosmosdb_primary_master_key
}


