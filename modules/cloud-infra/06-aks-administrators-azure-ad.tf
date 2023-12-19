# Administrator group for this cluster
resource "azuread_group" "aks_administrators" {
    display_name = "${var.resource_group_name_cluster_prefix}-${var.app}-${var.environment}-cluster-administrators"
    description = "Azure AKS administrators for the environment: ${var.app}-${var.environment}" 
    security_enabled = true
}

data "azuread_service_principal" "tf_sp" {
  client_id = var.tf_sp_client_id
}

# add service principal to the kubernetes administrator group
resource "azuread_group_member" "add_tf_sp_k8s_admin_group" {  
  group_object_id  = azuread_group.aks_administrators.id
  member_object_id = data.azuread_service_principal.tf_sp.object_id
}