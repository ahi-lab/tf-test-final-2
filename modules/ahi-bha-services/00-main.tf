#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }  
}

resource "helm_release" "bha_service_release" {
  name       = var.bha_service_release_name
  chart      = "${path.module}/ahi-chart"
  namespace  = var.bha_service_namespace
  create_namespace = var.create_namespace

  values = [ file("${path.module}/ahi-chart/values.yaml")]

  set {
      name  = "ahi.apigw.image"
      value = var.ahi_apigw_image
  }

  set {
      name  = "ahi.apigw.ingress.host"
      value = var.ahi_apigw_ingress_host
  }

    set {
      name  = "ahi.eureka.image"
      value = var.ahi_eureka_image
  }

  set {
      name  = "ahi.pactbroker.ingress.host"
      value = var.ahi_pactbroker_ingress_host
  }

  set {
      name  = "ahi.api.image"
      value = var.ahi_api_image
  }

  set {
      name  = "ahi.api.dataSource.database"
      value = var.ahi_api_dataSource_database
  }

  set {
      name  = "ahi.api.dataSource.uri"
      value = var.ahi_api_dataSource_uri
  }

  set {
      name  = "ahi.api.dataSource.key"
      value = var.ahi_api_dataSource_key
  }
}

