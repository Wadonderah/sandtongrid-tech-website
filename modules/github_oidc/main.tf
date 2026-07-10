# ==============================================================================
# GITHUB OIDC IAM ROLE
# ==============================================================================

# ------------------------------------------------------------------------------
# DATA SOURCES
# ------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {
  oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.existing[0].arn
}

# ------------------------------------------------------------------------------
# IAM ASSUME ROLE POLICY
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "github_oidc_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        local.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}/${var.github_repository}:*"
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# IAM ROLE
# ------------------------------------------------------------------------------

resource "aws_iam_role" "github_actions" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json

  tags = {
    Name        = var.role_name
    ManagedBy   = "Terraform"
    Environment = var.environment
    Purpose     = "GitHub Actions OIDC Role"
  }
}
