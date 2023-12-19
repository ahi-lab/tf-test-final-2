/*
## Step-02: Create External DNS
- External-DNS needs permissions to Azure DNS to modify (Add, Update, Delete DNS Record Sets)
- There are two ways in Azure to provide permissions to External-DNS pod 
  - Using Azure Service Principal
  - Using Azure Managed Service Identity (MSI)
- We are going to use `MSI` for providing necessary permissions here which is latest and greatest in Azure. 
*/

# azure_config_file for public external dns
resource "kubernetes_secret" "azure_config_file" {
  metadata {
    name = "azure-config-file"
    namespace = "kube-system"
  }

  data = {
    "azure.json" = jsonencode({
      "tenantId": var.tenant_id,
      "subscriptionId": var.subscription_id,
      "resourceGroup": var.az_dns_zone_rg_name,
      "useManagedIdentityExtension": true,
      "userAssignedIdentityID": var.azurerm_user_assigned_identity_client_id
    })
  }

  type = "Opaque"
}

data "template_file" "docs_external_dns_sa" {
    template = "${file("${path.module}/02-external-dns/external-dns-sa.yml")}"
}

data "template_file" "docs_external_dns_cr" {
    template = "${file("${path.module}/02-external-dns/external-dns-cr.yml")}"
}

data "template_file" "docs_external_dns_crb" {
    template = "${file("${path.module}/02-external-dns/external-dns-crb.yml")}"
}


# initialize the External DNS privilege
# public External DNS has the same privilege configuration as the private External DNS in cluster role level
resource "kubectl_manifest" "external_dns_sa" {   
    yaml_body = data.template_file.docs_external_dns_sa.rendered
}

resource "kubectl_manifest" "external_dns_cr" {   
    yaml_body = data.template_file.docs_external_dns_cr.rendered
    depends_on = [ kubectl_manifest.external_dns_sa ]
}

resource "kubectl_manifest" "external_dns_crb" {   
    yaml_body = data.template_file.docs_external_dns_crb.rendered
    depends_on = [ kubectl_manifest.external_dns_cr ]
}

data "template_file" "external_dns_template_public" {
  template = "${file("${path.module}/02-external-dns/templates/external-dns-public-template.yml")}"

  vars = {
          txt-owner-id = var.aks_cluster_name
          domain-filter =  var.az_dns_zone_name
          azure-resource-group-public = var.az_dns_zone_rg_name          
  }
}


resource "kubectl_manifest" "external_dns_public" {    
    yaml_body = data.template_file.external_dns_template_public.rendered
    depends_on = [helm_release.cert_manager, kubectl_manifest.external_dns_crb]
}