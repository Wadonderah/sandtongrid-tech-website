###############################################################
# GitHub Actions OpenID Connect Provider
#
# This resource establishes trust between AWS IAM and GitHub
# Actions. It allows GitHub to request temporary AWS credentials
# without storing long-lived IAM Access Keys.
#
# This is created once per AWS account and reused by all
# GitHub repositories.
###############################################################

###############################################################
# GitHub TLS Certificate
#
# Retrieves GitHub's public certificate so AWS can verify
# the authenticity of GitHub's identity tokens.
###############################################################

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

###############################################################
# GitHub OIDC Provider
#
# Registers GitHub as a trusted identity provider inside IAM.
###############################################################

resource "aws_iam_openid_connect_provider" "github" {

  count = var.create_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name      = "github-actions-oidc-provider"
    ManagedBy = "Terraform"
    Purpose   = "GitHub Actions OIDC Authentication"
  }
}

###############################################################
# Existing GitHub OIDC Provider (looked up, not created)
#
# Used by every environment after the first one, since the
# provider itself only needs to exist once per AWS account.
###############################################################

data "aws_iam_openid_connect_provider" "existing" {

  count = var.create_oidc_provider ? 0 : 1

  url = "https://token.actions.githubusercontent.com"

}
