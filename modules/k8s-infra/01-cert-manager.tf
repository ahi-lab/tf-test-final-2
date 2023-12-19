
# create namespace of cert manager
resource "kubernetes_namespace" "cert_manager" { 
  metadata {
    name        = var.cert_manager_namespace
  }
  depends_on = [azuread_application_password.create_sp_cluter_issuer_password]
}

# install cert manager through helm
resource "helm_release" "cert_manager" {
    name             = var.cert_manager_release_name
    chart            = var.cert_manager_chart
    namespace        = var.cert_manager_namespace
    repository       = var.cert_manager_repository
    version          = var.cert_manager_chart_version  
    create_namespace = var.create_namespace

    values = [ file("${path.module}/01-cert-manager/values.yml")]

    set {
        name  = "startupapicheck.timeout"
        value = "5m"
    }

    set {
        name  = "installCRDs"
        value = var.cert_manager_crd_flag
    }

    set {
        name  = "namespaceLabels.cert-manager.cert-manager.io/disable-validation"
        value = true
    }

    // depends_on = [kubernetes_namespace.cert_manager, local_file.cluster_issuer_template, local_file.external_dns_template]
    depends_on = [kubernetes_namespace.cert_manager]
}

# create a new password for the application cluster issuer 
# the applicate was created after the cluster created, it is used for cluster issuer access configuration
resource "azuread_application_password" "create_sp_cluter_issuer_password" {
  application_object_id = var.aks_app_cluster_issuer_object_id
  end_date              = "2030-01-01T01:00:00Z"  
}

# create secrete to handle the application password 
resource "kubernetes_secret" "azuredns_config" {
  metadata {
    name = "azuredns-config"
    namespace = "cert-manager"
  }

  data = {
    "client-secret" = nonsensitive(azuread_application_password.create_sp_cluter_issuer_password.value)
  }
  depends_on = [kubernetes_namespace.cert_manager]
}


data "template_file" "cluster_issuer_template" {
  

  template = "${file("${path.module}/01-cert-manager/template/cluster-issuer-template.yml")}"

  vars = {
          clientID = var.aks_sp_cluster_issuer_password_sp_application_id
          subscriptionID = var.subscription_id
          tenantID = var.tenant_id
          resourceGroupName  = var.az_dns_zone_rg_name
          hostedZoneName = var.az_dns_zone_name  
  }
}

resource "kubectl_manifest" "cluster_issuer" {    
    yaml_body = data.template_file.cluster_issuer_template.rendered
    depends_on = [helm_release.cert_manager, kubernetes_secret.azuredns_config]
}