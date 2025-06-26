#---------#
# General #
#---------#
variable "region" {
  description = "Name of AWS Region."
  type        = string
  default     = "us-east-1"
}

variable "allow_deployment_from_local" {
  type = object({
    sso_base_admin_role = optional(bool, false)
    sso_developer_role  = optional(bool, false)
  })
  description = "Add/remove assume permissions for these two roles. By default it's disabled!"
}

variable "allow_iam_user_assume" {
  type        = bool
  default     = false
  description = "Whether to allow IAM user to assume the role or not"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to be applied on each resource. You can get required tags [here](https://cloud.merck.com/documentation/compliance/tagging-standards/index.html)"
  validation {
    condition     = length(setintersection(keys(var.default_tags), ["DataClassification", "Consumer", "Application", "Environment", "Service"])) >= length(["DataClassification", "Consumer", "Application", "Environment", "Service"])
    error_message = "Keys: DataClassification, Consumer, Application, Environment, Service are required!"
  }
}

#-----------------#
# Deployment Role #
#-----------------#
variable "deployment_role_name" {
  type        = string
  description = "The name you would like to specify for your deployment role"
  default     = "deployment-role"
}

variable "deployment_role_policy_name" {
  type        = string
  description = "The name you would like to specify for your the policy attached to your deployment role"
  default     = "deployment-role-policy"
}

variable "deployment_user_assume_role_policy_name" {
  type        = string
  description = "The name you would like to specify for your the IAM policy which establishes trust between you IAM user and deployment role"
  default     = "deployment-user-assume-role-policy"
}

variable "deployment_user" {
  type        = string
  description = "The name you would like to specify for your the IAM policy which establishes trust between you IAM user and deployment role"
  default     = "srv_deployment_user" # This is the standard across all AWS Accounts at Merck
}

#-----------#
# OIDC Role #
#-----------#
variable "create_oidc_role" {
  type        = bool
  default     = false
  description = "Whether to create OIDC role or not"
}

variable "oidc_role_name" {
  type        = string
  description = "The name you would like to specify for your OIDC role"
  default     = "github-oidc"
}

variable "oidc_role_policy_name" {
  type        = string
  description = "The name you would like to specify for your the policy attached to your OIDC role"
  default     = "oidc-role-policy"
}

variable "subjects" {
  type        = list(string)
  description = "List of subjects to be added to the OIDC role. Eg. merck-gen:my-repo-name:*"
}

variable "backend" {
  type = object({
    bucket         = string
    dynamodb_table = string
  })
  description = "Pass the bucket name and dynamodb table name which you are using in the backend.env.conf file."
}
