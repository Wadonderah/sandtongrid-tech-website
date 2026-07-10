
output "website_domain" {
  description = "Website domain."
  value       = var.domain_name


}

output "bucket_name" {
  description = "s3 Bucket."
  value       = var.bucket_name

}

output "region" {
  description = "Deployment region."
  value       = var.aws_region

}
###############################################################
# GitHub Actions IAM Role ARN
#
# This ARN will be used when configuring GitHub Actions to
# authenticate with AWS using OIDC.
###############################################################

output "github_actions_role_arn" {
  description = "IAM Role ARN for GitHub Actions."
  value       = module.github_oidc.role_arn
}
