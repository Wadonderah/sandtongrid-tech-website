# ==============================================================================
# GITHUB OIDC OUTPUTS
# ==============================================================================

output "role_arn" {
  description = "ARN of the GitHub Actions OIDC IAM role"
  value       = aws_iam_role.github_actions.arn
}

output "role_name" {
  description = "Name of the GitHub Actions OIDC IAM role"
  value       = aws_iam_role.github_actions.name
}

output "role_id" {
  description = "ID of the GitHub Actions OIDC IAM role"
  value       = aws_iam_role.github_actions.id
}

output "assume_role_policy" {
  description = "Assume role policy document JSON"
  value       = data.aws_iam_policy_document.github_oidc_assume_role.json
}
