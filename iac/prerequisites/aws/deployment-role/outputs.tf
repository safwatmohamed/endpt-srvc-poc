# Outputs
output "deployment_role_arn" {
  value       = aws_iam_role.deployment_role.arn
  description = "Deployment Role ARN"
}

output "oide_role_arn" {
  value       = module.oidc_role.arn
  description = "OIDC Role ARN"
}