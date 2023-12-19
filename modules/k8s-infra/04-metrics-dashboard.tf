data "template_file" "docs_metrics_dashboard_aks_admin_service_account" {
    template = "${file("${path.module}/04-metrics-dashboard/aks-admin-service-account.yml")}"
}

data "template_file" "docs_metrics_dashboard_aks_admin_role_binding" {
    template = "${file("${path.module}/04-metrics-dashboard/aks-admin-role-binding.yml")}"
}

data "template_file" "docs_metrics_dashboard_aks_admin_service_account_token" {
    template = "${file("${path.module}/04-metrics-dashboard/aks-admin-service-account-token.yml")}"
}   

resource "kubernetes_namespace" "kubernetes_dashboard" { 
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "kubectl_manifest" "metrics_dashboard_aks_admin_service_account" {   
    yaml_body = data.template_file.docs_metrics_dashboard_aks_admin_service_account.rendered
}

resource "kubectl_manifest" "metrics_dashboard_aks_admin_role_binding" {   
    yaml_body = data.template_file.docs_metrics_dashboard_aks_admin_role_binding.rendered
    depends_on = [kubectl_manifest.metrics_dashboard_aks_admin_service_account]
}

resource "kubectl_manifest" "metrics_dashboard_aks_admin_service_account_token" {   
    yaml_body = data.template_file.docs_metrics_dashboard_aks_admin_service_account_token.rendered
    depends_on = [kubectl_manifest.metrics_dashboard_aks_admin_service_account]
}


# create pulic ingress-nginx through helm
resource "helm_release" "dashboard" {
    name             = var.k8s_dashboard_release_name
    chart            = var.k8s_dashboard_chart
    namespace        = var.k8s_dashboard_namespace
    repository       = var.k8s_dashboard_repository
    version          = var.k8s_dashboard_chart_version

    create_namespace = var.create_namespace
    depends_on = [kubernetes_namespace.kubernetes_dashboard]
}