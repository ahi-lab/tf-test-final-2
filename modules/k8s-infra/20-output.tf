#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

data "azurerm_client_config" "current" {}

output "subscription_id"{
    value = data.azurerm_client_config.current.subscription_id
}

output "tenant_id"{
    value = data.azurerm_client_config.current.tenant_id
}

output "aks_sp_cluster_issuer_password_non_sensitive" {    
    value = nonsensitive(azuread_application_password.create_sp_cluter_issuer_password.value)
}

output "dashboard_url" {
    value = "${var.metrics_dashboard_host}/dashboard"  
}