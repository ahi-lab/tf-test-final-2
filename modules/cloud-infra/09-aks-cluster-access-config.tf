# After the cluster adminitrator group is created, roles will be assigned to it 
# so that the users in this group can manage AKS
data "azurerm_role_definition" "aks_cluster_user" {
  name = "Azure Kubernetes Service Cluster User Role"
}

# assign cluster user role to cluster
resource "azurerm_role_assignment" "aks_cluster_admin_group_role" {
  scope                = azurerm_kubernetes_cluster.aks_cluster.id  
  role_definition_name = data.azurerm_role_definition.aks_cluster_user.name
  principal_id         = azuread_group.aks_administrators.object_id
}

data "azurerm_dns_zone" "dns_zone" {
  name                = var.az_dns_zone_name
  resource_group_name = var.az_dns_zone_resource_group_name
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# create a service principal which is used for cert manager cluster issuer
resource "azuread_application" "cluster_issuer_app" {
  display_name = var.aks_cluster_issuer_sp_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "cluster_issuer_sp" {
  application_id               = azuread_application.cluster_issuer_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}


# assign role 'DNS Zone Contributor' to the service princal
# so that cluster issuer of cert manager can access the public dns zone
# to issue a Certificate when challenge happens
resource "azurerm_role_assignment" "assignment_sp" {
  # principal_id                     = data.azuread_application.aks_app_cluster_issuer.application_id
  principal_id                     = azuread_service_principal.cluster_issuer_sp.object_id
  scope                            = data.azurerm_dns_zone.dns_zone.id
  role_definition_name             = "DNS Zone Contributor"
  skip_service_principal_aad_check = true
  depends_on = [azuread_service_principal.cluster_issuer_sp]
}


data "azurerm_user_assigned_identity" "managed_identity_agent_pool" {
  name                = "${azurerm_kubernetes_cluster.aks_cluster.name}-agentpool"
  
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

data "azurerm_resource_group" "az_dns_zone_rg" {    
    name = var.az_dns_zone_resource_group_name
}


# configure managed identity cluster 'agent pool' to have role 'Contributor' on public azure dns resource group
# External DNS will be configured to use this managed identity to access azure DNS Zone
# so that External DNS can access the public DNS Zone
resource "azurerm_role_assignment" "assignment_mi" {
  principal_id                     = data.azurerm_user_assigned_identity.managed_identity_agent_pool.principal_id
  scope                            = data.azurerm_resource_group.az_dns_zone_rg.id
  role_definition_name             = "Contributor"
  skip_service_principal_aad_check = true
  depends_on = [azuread_service_principal.cluster_issuer_sp]
}



# !Important
# Permission grants to cluster Managed Identity used by Azure Cloud provider may take up 60 minutes to populate.
# Without this role, internal nginx ingress service cannot get a private ip address
# It happens when we create an AKS cluster with specific vnet and enabled CNI feature.
resource "azurerm_role_assignment" "assignment_vnet" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
  scope                            = azurerm_virtual_network.aks-vnet.id
  role_definition_name             = "Contributor"
  skip_service_principal_aad_check = true
  depends_on = [azurerm_kubernetes_cluster.aks_cluster, azurerm_virtual_network.aks-vnet]
}

