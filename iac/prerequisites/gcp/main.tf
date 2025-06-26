######################################################
#####      DEPLOYMENT SERVICE ACCOUNT ROLES      #####
# Add roles to your service account via .tfvars file #
######################################################

resource "google_project_iam_member" "project_deployment_sa" {
  for_each = var.roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${var.deployment_service_account}"
}