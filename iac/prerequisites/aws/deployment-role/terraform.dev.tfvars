#########################################################################################
#### UNCOMMENT lines below if you'd like to change from the defaults in variables.tf ####
#########################################################################################
### General ###
# region = ""
# allow_deployment_from_local = {
#   sso_base_admin_role = true
#   sso_developer_role  = false
# }
# backend = {
#   bucket         = "BACKEND_BUCKET"
#   dynamodb_table = "BACKEND_DYNAMODB_TABLE"
# }
# allow_iam_user_assume = false

### Deployment Role ###
# deployment_role_name                    = ""
# deployment_role_policy_name             = ""
# deployment_user_assume_role_policy_name = ""
# deployment_user                         = ""

### OIDC Role ###
# create_oidc_role      = false
# oidc_role_name        = ""
# oidc_role_policy_name = ""
subjects = ["merck-gen/YOUR_REPO_NAME:*"] # Please specify your repository name here.

### Update according to Cloud Tagging Standards ###
# https://cloud.merck.com/documentation/compliance/tagging-standards/index.html
default_tags = {
  DataClassification = "Proprietary"
  Consumer           = "YOUR_EMAIL@merck.com"
  Application        = "YOUR_APP"
  Environment        = "Development"
  Service            = "Development"
}
