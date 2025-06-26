# Variables

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "region" {
  description = "The region in which to create the bucket."
  type        = string
}

variable "deployment_service_account" {
  description = "The deployment service account. The value should be passed during GitHub Actions runtime."
  type        = string
}

variable "roles" {
  description = "The roles to grant the deployment service account."
  type        = set(string)
}