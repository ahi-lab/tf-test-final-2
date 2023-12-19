resource "kubernetes_namespace" "ingress-nginx" { 
  metadata {
    name        = var.ingress_nginx_namespace
  }
}

# create pulic ingress-nginx through helm
resource "helm_release" "ingress-nginx" {
    name             = var.ingress_nginx_release_name
    chart            = var.ingress_nginx_chart
    namespace        = var.ingress_nginx_namespace
    repository       = var.ingress_nginx_repository
    version          = var.ingress_nginx_chart_version 

    create_namespace = var.create_namespace

    values = [ file("${path.module}/03-ingress-nginx/values.yml")]

    set {
        name  = "controller.replicaCount"
        value = 2
    }
    
    set {
        name  = "controller.nodeSelector.app"
        value = "system-apps"
    }

    set {
        name  = "controller.admissionWebhooks.patch.nodeSelector.app"
        value = "system-apps"
    }

    set {
        name  = "controller.admissionWebhooks.patch.image.digest"
        value = ""
    }

    set {
        name  = "defaultBackend.nodeSelector.app"
        value = "system-apps"
    }

    set {
        name  = "controller.extraArgs.enable-ssl-passthrough"
        value = ""
    }

    set {
        name  = "controller.service.externalTrafficPolicy"
        value = "Local"
    }

    set {
        name  = "controller.service.loadBalancerIP"
        value = var.ingress_public_ip_address
    }

    set {
        name  = "prometheus.create"
        value = true
    }

    depends_on = [kubernetes_namespace.ingress-nginx]
}