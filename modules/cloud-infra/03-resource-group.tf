# Cluster resource group
resource "azurerm_resource_group" "aks-cluster-rg" {
    name = "${var.resource_group_name_cluster_prefix}-${var.app}-${var.environment}-rg"
    location = var.location
}