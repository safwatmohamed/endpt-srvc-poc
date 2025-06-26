# Provider versions

terraform {
  required_version = ">= 1.3"

  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

### Impersonate the Deployment Service Account ###
data "google_service_account_access_token" "default" {
  provider               = google
  target_service_account = var.deployment_service_account
  scopes                 = ["cloud-platform"]
  lifetime               = "300s"
}

provider "google" {
  alias        = "deployment_sa_alias"
  access_token = data.google_service_account_access_token.default.access_token
  project      = var.project_id
  region       = var.region
}