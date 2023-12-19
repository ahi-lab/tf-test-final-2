#
# AHI Cloud
# Terraform v1.0
# Copyright (c) AHI
#

terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
  }
}
