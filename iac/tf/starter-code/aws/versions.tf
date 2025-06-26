# Provider versions

terraform {
  required_version = ">= 0.13.1"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.27"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
  assume_role {
    role_arn = "arn:aws:iam::${var.account_no}:role/${var.deployment_role}"
  }
}