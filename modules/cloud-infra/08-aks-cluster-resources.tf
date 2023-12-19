# Provision AKS Cluster
/*
1. Add Basic Cluster Settings
  - Get Latest Kubernetes Version from datasource (kubernetes_version) to see if 'Stackgres' supports
  - Do not use the latest version, the latest Kubernetes version might not support Component 'Stackgres'
  - Provide a specific version is necessory
  - Add Node Resource Group (node_resource_group)
2. Add Default Node Pool Settings
  - orchestrator_version (kubernetes version using datasource)
  - availability_zones
  - enable_auto_scaling
  - max_count, min_count
  - os_disk_size_gb
  - type
  - node_labels
  - tags
3. Enable MSI
4. Add On Profiles 
  - Azure Policy
  - Azure Monitor (Reference Log Analytics Workspace id)
5. RBAC & Azure AD Integration
6. Admin Profiles
  - Windows Admin Profile
  - Linux Profile
7. Network Profile
8. Cluster Tags
9. Node pools
   - API
   - Database Cluster
*/


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                               =  "${var.resource_group_name_cluster_prefix}-${var.app}-${var.environment}-cluster"
  location                           =  azurerm_resource_group.aks-cluster-rg.location
  resource_group_name                =  azurerm_resource_group.aks-cluster-rg.name
  dns_prefix                         =  "${var.resource_group_name_cluster_prefix}-${var.app}-${var.environment}-cluster"
  # kubernetes_version                 =  data.azurerm_kubernetes_service_versions.current.latest_version
  kubernetes_version                 =  var.aks_k8s_version
  node_resource_group                =  "${var.resource_group_name_cluster_prefix}-${var.app}-${var.environment}-node-rg"
  azure_policy_enabled               =  true
  sku_tier                           =  "Standard"
  role_based_access_control_enabled  =  true
  

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [azuread_group.aks_administrators.object_id]
    azure_rbac_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  default_node_pool {
      name                 = "systempool"
      vm_size              = "Standard_D4s_v3"
      # orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
      orchestrator_version = var.aks_k8s_version
      zones                = [1, 2]
      enable_auto_scaling  = true
      node_count           = 1
      min_count            = 1
      max_count            = 10
      os_disk_size_gb      = 30
      max_pods               = 100
      os_disk_type         = "Managed"
      type                 = "VirtualMachineScaleSets"
      os_sku               = "Ubuntu"      
      vnet_subnet_id       = azurerm_subnet.aks-subnet-default.id      
      
      node_labels = {        
          "nodepool-type"                 = "system"
          "app"                           = "system-apps"
          "nodepoolos"                    = "linux"
          "linkerd.io/control-plane-ns"   = "linkerd"
      }

      tags = {
          "nodepool-type"                 = "system"
          "app"                           = "system-apps"
          "nodepoolos"                    = "linux"
      }
  }
  
  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  # Windows Profile
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }

  # Linux Profile
  linux_profile {
    admin_username = var.linux_admin_username
    ssh_key {
      # key_data = file(var.ssh_public_key)
      key_data = file("${path.module}/../../aks-sshkeys/${var.ssh_public_key}")
    }
  }

  # Network Profile
  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.aks_dns_service_ip
    service_cidr = var.aks_service_cidr
  }

  tags = {
    Environment = "External"
  }
}

# Get access credentials for a managed Kubernetes cluster. 
# resource "null_resource" "get_credentials_created_cluster" {
#   provisioner "local-exec" {
#     command="az aks get-credentials -g ${azurerm_resource_group.aks-cluster-rg.name} -n ${azurerm_kubernetes_cluster.aks_cluster.name} --overwrite-existing --admin"
#   }
# }


# # Use local-exec provisioner to query AKS cluster status
# resource "null_resource" "check_aks_status" {
#   provisioner "local-exec" {
#     command = <<-EOT
#       # Check AKS status and set output based on the provisioning state
#       status=$(az aks show --resource-group ${azurerm_resource_group.aks-cluster-rg.name} --name ${azurerm_kubernetes_cluster.aks_cluster.name} --query "provisioningState" -o tsv)

#       if [ "$status" = "Succeeded" ]; then
#         echo "true" > aks_ready.txt
#       else
#         echo "false" > aks_ready.txt
#       fi
#     EOT
#   }

#   # Rerun the provisioner if aks_cluster changes
#   triggers = {
#     always_run = "${timestamp()}"
#   }
# }