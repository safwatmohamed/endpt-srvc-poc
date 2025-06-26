# Variables

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "region" {
  description = "The region in which to deploy resources."
  type        = string
}

variable "deployment_service_account" {
  description = "The deployment service account. The value should be passed during GitHub Actions runtime."
  type        = string
}