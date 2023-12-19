/* 
  Create Azure Virtual Network
  Create Four subnets:
        one for 'system' node pool of AKS Cluster 
        and others for the 'user' node pools and Azure Virtual Nodes
  */

# Virtual network
resource "azurerm_virtual_network" "aks-vnet" {
  name                = "aks-${var.app}-${var.environment}-vnet"
  address_space       = [var.aks_vnet_address_space]
  location            = azurerm_resource_group.aks-cluster-rg.location
  resource_group_name = azurerm_resource_group.aks-cluster-rg.name
}

# Default subnet
resource "azurerm_subnet" "aks-subnet-default" {
  name                 = "aks-${var.app}-${var.environment}-subnet-default"
  resource_group_name  = azurerm_resource_group.aks-cluster-rg.name
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  address_prefixes     = [var.aks_subnet_default_address_space] 
}