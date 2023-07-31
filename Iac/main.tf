# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "veronafinal-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}