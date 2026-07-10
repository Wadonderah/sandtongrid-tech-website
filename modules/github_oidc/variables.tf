# ==============================================================================
# GITHUB OIDC VARIABLES
# ==============================================================================

variable "github_owner" {
  description = "GitHub organization or username that owns the repository"
  type        = string
}

variable "github_repository" {
  description = "Name of the GitHub repository"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
  default     = "github-actions-terraform"
}

variable "environment" {
  description = "Deployment environment (e.g. prod, dev, stage)."
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether to create the GitHub OIDC provider. This is an AWS-account-wide singleton (one per account, not per environment) — set this to false for every environment except the first one that creates it, and they'll all look it up instead."
  type        = bool
  default     = true
}
