data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_roles" "sso_developer_role" {
  name_regex  = "AWSReservedSSO_developer-role_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

data "aws_iam_roles" "sso_base_admin_role" {
  name_regex  = "AWSReservedSSO_standard-base-admin-role_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

locals {
  sso_developer_arns  = tolist(data.aws_iam_roles.sso_developer_role.arns)
  sso_base_admin_arns = tolist(data.aws_iam_roles.sso_base_admin_role.arns)
}

# Use standard-base-admin-role to perform initial deployment via Local
# Use GitHub Actions to update deployment-role policy via OIDC role in subsequent deployments
provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

terraform {
  backend "s3" {}
}

module "oidc_role" {
  source  = "artifacts.merck.com/terraform-iac-shared__terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 2.2"

  create   = var.create_oidc_role
  name     = var.oidc_role_name
  subjects = var.subjects
  policies = {
    oidc_role_policy = aws_iam_policy.oidc_role_policy.arn
  }

  default_tags = var.default_tags
}

resource "aws_iam_policy" "oidc_role_policy" {
  name = var.oidc_role_policy_name
  policy = templatefile("oidc_role_policy.json", {
    BACKEND_BUCKET         = var.backend.bucket
    ACCOUNT_ID             = data.aws_caller_identity.current.account_id
    BACKEND_DYNAMODB_TABLE = var.backend.dynamodb_table
    REGION                 = var.region
  })
  description = "OIDC role IAM policy"
}

resource "aws_iam_role" "deployment_role" {
  name = var.deployment_role_name
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            AWS = concat(
              var.allow_iam_user_assume ? [
                "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:user/${var.deployment_user}"
              ] : [],
              var.allow_deployment_from_local.sso_base_admin_role ? local.sso_base_admin_arns : [],
              var.allow_deployment_from_local.sso_developer_role ? local.sso_developer_arns : [],
              var.create_oidc_role ? [module.oidc_role.arn] : [],
            )
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "deployment_role_policy" {
  name = var.deployment_role_policy_name
  policy = templatefile("deployment_policy.json", {
    BACKEND_BUCKET         = var.backend.bucket
    ACCOUNT_ID             = data.aws_caller_identity.current.account_id
    BACKEND_DYNAMODB_TABLE = var.backend.dynamodb_table
    REGION                 = var.region
  })
  description = "Deployment role IAM policy"
}

resource "aws_iam_role_policy_attachment" "deployment_role_policy_attachment" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.deployment_role_policy.arn
}

resource "aws_iam_policy" "deployment_user_assume_role_policy" {
  count       = var.allow_iam_user_assume ? 1 : 0
  name        = var.deployment_user_assume_role_policy_name
  description = "IAM policy allowing role assumption to deployment role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.deployment_role.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "deployment_user_assume_role_policy_attachment" {
  count      = var.allow_iam_user_assume ? 1 : 0
  user       = var.deployment_user
  policy_arn = aws_iam_policy.deployment_user_assume_role_policy[0].arn
}

moved {
  from = aws_iam_policy.deployment-role-policy
  to   = aws_iam_policy.deployment_role_policy
}

moved {
  from = aws_iam_policy.deployment-user-assume-role-policy
  to   = aws_iam_policy.deployment_user_assume_role_policy
}
