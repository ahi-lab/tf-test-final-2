#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

output "get_k8s_credential" {
  value = module.cloud-infra.az_aks_get_credentials
}

output "get_dashboard_access_token" {
  value = "kubectl describe secret aks-admin-token -n kube-system"
}