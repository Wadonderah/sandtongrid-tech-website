###############################################################
# GitHub Actions IAM Policies - Least Privilege
#
# Split into three managed policies (storage, delivery,
# identity) because AWS caps a single managed policy at 6144
# characters and this project's full permission set doesn't fit
# in one. Each document lives in its own iam_policy_*.tf file,
# built entirely from variables/locals — no account IDs, bucket
# names, or resource IDs are hardcoded here.
###############################################################

locals {
  policy_base_name = "${replace(var.project_name, " ", "-")}-github-actions-${var.environment}"
}

resource "aws_iam_policy" "github_actions_storage" {

  name        = "${local.policy_base_name}-storage"
  description = "GitHub Actions permissions: S3 buckets, DynamoDB lock table, KMS."

  policy = data.aws_iam_policy_document.github_actions_storage.json

  tags = merge(var.tags, {
    Name      = "${local.policy_base_name}-storage"
    ManagedBy = "Terraform"
    Purpose   = "GitHub Actions Least Privilege Policy"
  })
}

resource "aws_iam_policy" "github_actions_delivery" {

  name        = "${local.policy_base_name}-delivery"
  description = "GitHub Actions permissions: CloudFront, WAFv2, ACM, Route53."

  policy = data.aws_iam_policy_document.github_actions_delivery.json

  tags = merge(var.tags, {
    Name      = "${local.policy_base_name}-delivery"
    ManagedBy = "Terraform"
    Purpose   = "GitHub Actions Least Privilege Policy"
  })
}

resource "aws_iam_policy" "github_actions_identity" {

  name        = "${local.policy_base_name}-identity"
  description = "GitHub Actions permissions: IAM self-management, STS, SNS, CloudWatch."

  policy = data.aws_iam_policy_document.github_actions_identity.json

  tags = merge(var.tags, {
    Name      = "${local.policy_base_name}-identity"
    ManagedBy = "Terraform"
    Purpose   = "GitHub Actions Least Privilege Policy"
  })
}
