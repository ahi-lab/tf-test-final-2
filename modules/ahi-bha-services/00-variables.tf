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

# Cert Manager Variables
variable "bha_service_release_name" {
  type        = string  
  default     = "bha-service"
}

variable "bha_service_namespace" {
  type        = string  
  default     = "bha-service"
}

variable "ahi_apigw_image" {
  type        = string  
  default = "samuelest/apigw:1.14"
}

variable "ahi_apigw_ingress_host" {
  type        = string  
  default = "api.az1-ahi.com"
}

variable "ahi_eureka_image" {
  type        = string  
  default = "samuelest/eureka-server:1.14"
}

variable "ahi_pactbroker_ingress_host" {
  type        = string  
  default = "pact.az1-ahi.com"
}

variable "ahi_api_image" {
  type        = string  
  default = "samuelest/bha-backend-api:1.14"
}

variable "ahi_api_dataSource_database" {
  type        = string  
  default = "dGthaGlkYg=="
}

variable "ahi_api_dataSource_uri" {
  type        = string  
  default = "aHR0cHM6Ly9haGktYmhhLWNvc21vcy1kZXYuZG9jdW1lbnRzLmF6dXJlLmNvbTo0NDMv"
}

variable "ahi_api_dataSource_key" {
  type        = string  
  default = "TTRWNXJXWHpBZFl2MFQzaDA2Y0JNSXQ0a0VmYlhNaTR2VWU0d2x4YjFUMlN0OTcybVA3YVpuOGNZcmV1ZkpWdG4wZXpCSHp4YWlsVEFDRGJJVDFQdWc9PQ=="
}