######################### Dashboard ###########################
data "template_file" "ingress_dashboard_host_public" {
  template = "${file("${path.module}/07-components-ingress/dashboard-ingress.yml")}"

  vars = {
          host = var.metrics_dashboard_host
  }
}

resource "kubectl_manifest" "ingress_dashboard_host" {
    yaml_body = data.template_file.ingress_dashboard_host_public.rendered
    depends_on = [kubectl_manifest.cluster_issuer, helm_release.ingress-nginx]
}