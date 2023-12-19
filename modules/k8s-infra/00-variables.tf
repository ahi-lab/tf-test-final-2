#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

# Reused Variables
variable "create_namespace" {
  type        = bool  
  default     = true
}

variable "subscription_id" {
  type        = string    
}

variable "tenant_id" {
  type        = string    
}

variable "aks_cluster_issuer_sp_name" {
    type = string
    description = "This is AKs subnet virtual nodes address space"
    default = "aks_cluster_issuer_service_principal"
}

variable "az_dns_zone_rg_name" {
    type = string
    description = "This is DNS Zone Resource Group Name"
    default = "dns-zone"
}

variable "az_dns_zone_name" {
    type = string
    description = "This is DNS Zone Name"
    default = "az1-ahi.com"
}

variable "aks_cluster_name" {
    type = string
    description = "This is AKS cluster name"
    default = "aks-external-cluster"
}

variable "aks_cluster_node_rg_name" {
    type = string
    description = "This is AKS cluster node resource group name"
    default = "aks-external-node-rg"
}

# Cert Manager Variables
variable "cert_manager_release_name" {
  type        = string  
  default     = "cert-manager"
}

variable "cert_manager_namespace" {
  type        = string  
  default     = "cert-manager"
}

variable "cert_manager_chart" {
  type        = string  
  default     = "cert-manager"
}

variable "cert_manager_repository" {
  type        = string  
  default     = "https://charts.jetstack.io"
}

variable "cert_manager_chart_version" {
  type        = string  
  default     = "1.11.1"
}

variable "cert_manager_crd_flag" {
  type        = bool  
  default     = true
}

variable "cert_manager_ns_desc" {
  type        = string  
}

# variable "aks_sp_cluster_issuer_object_id" {
#   type        = string
# }

variable "aks_app_cluster_issuer_object_id" {
  type        = string
}

variable "aks_sp_cluster_issuer_password_sp_application_id" {
  type        = string
}

variable "azurerm_user_assigned_identity_client_id" {
  type        = string
}


# K8S Dashboard
variable "k8s_dashboard_release_name" {
  type        = string  
  default     = "k8s-dashboard"
}

variable "k8s_dashboard_namespace" {
  type        = string  
  default     = "kubernetes-dashboard"
}

variable "k8s_dashboard_chart" {
  type        = string  
  default     = "kubernetes-dashboard"
}

variable "k8s_dashboard_repository" {
  type        = string  
  default = "https://kubernetes.github.io/dashboard/"
}

variable "k8s_dashboard_chart_version" {
  type        = string  
  default     = "6.0.0"
}


# Ingress Nginx Public
variable "ingress_nginx_release_name" {
  type        = string  
  default     = "ingress-nginx"
}

variable "ingress_nginx_namespace" {
  type        = string  
  default     = "ingress-nginx"
}

variable "ingress_nginx_chart" {
  type        = string  
  default     = "ingress-nginx"
}

variable "ingress_nginx_repository" {
  type        = string  
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "ingress_nginx_chart_version" {
  type        = string  
  default     = "4.6.0"
}

# Ingress Nginx Internal Private
variable "ingress_nginx_release_name_internal" {
  type        = string  
  default     = "ingress-nginx-internal"
}

variable "ingress_nginx_namespace_internal" {
  type        = string  
  default     = "ingress-nginx-internal"
}

variable "ingress_nginx_classname_internal" {
  type        = string  
  default     = "internal-nginx"
}

variable "ingress_public_ip_address" {
  type        = string
}


# Prometheus and Grafana
variable "aks_grafana_admin_user" {
  type        = string  
  default     = "admin"
}

variable "aks_grafana_admin_password" {
  type        = string  
  default     = "p@ssw0rd$1%-#"
}

variable "prometheus_release_name" {
  type        = string  
  default     = "prometheus"
}

variable "prometheus_namespace" {
  type        = string  
  default     = "monitoring"
}

variable "prometheus_chart" {
  type        = string  
  default     = "kube-prometheus-stack"  
}

variable "prometheus_repository" {
  type        = string  
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "prometheus_chart_version" {
  type        = string    
  default     = "45.27.1"
}


# Stackgres Operator
variable "stackgres_release_name" {
  type        = string  
  default     = "stackgres"
}

variable "stackgres_namespace" {
  type        = string  
  default     = "stackgres"
}

variable "stackgres_chart" {
  type        = string  
  default     = "stackgres-operator"  
}

variable "stackgres_repository" {
  type        = string  
  default     = "https://stackgres.io/downloads/stackgres-k8s/stackgres/helm/"
}

variable "stackgres_chart_version" {
  type        = string    
  default     = "1.4.3"
}


# hosts
variable "linkerd_viz_host" {
    type = string    
    default = "linkerd.az1-ahi.com"
}

variable "metrics_dashboard_host" {
    type = string    
    default = "dashboard.az1-ahi.com"
}


variable "kubeconfig" {
  type = string
}