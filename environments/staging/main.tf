
# ROOT MODULE
#
# Project:
# Sandtongrid Technologies Website
#
# Purpose:
# This file orchestrates the deployment of the complete
# AWS infrastructure for the static website.
#
# Architecture:
#
#                 Route53
#                    │
#                    ▼
#              CloudFront
#                    │
#          Origin Access Control
#                    │
#                    ▼
#            Private Amazon S3
#
# Services Used:
# - Amazon S3
# - Amazon CloudFront
# - AWS Certificate Manager
# - Amazon Route53
#


###############################################################
# Local Values
###############################################################

locals {

  origin_id = "${var.project_name}-${var.environment}-origin"

}


# S3 MODULE
#
# Creates:
# - Private S3 Bucket
# - Versioning
# - Encryption
# - Ownership Controls
# - Public Access Block


module "s3" {

  source = "../../modules/s3"

  bucket_name = var.bucket_name

  tags = var.tags

}


# ACM MODULE
#
# Creates an SSL certificate in us-east-1
# (Required by CloudFront)


module "acm" {

  source = "../../modules/acm"

  providers = {
    aws.virginia = aws.virginia
  }

  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id

  tags = var.tags

}


# LOGGING MODULE
#
# Creates the S3 bucket CloudFront delivers standard
# access logs into.


module "logging" {

  source = "../../modules/logging"

  project_name = var.project_name
  environment  = var.environment

  tags = var.tags

}


# CLOUDFRONT MODULE
#
# Creates:
# - Origin Access Control (OAC)
# - CloudFront Distribution
# - Bucket Policy Document


module "cloudfront" {
  source = "../../modules/cloudfront"

  providers = {
    aws.virginia = aws.virginia
  }

  project_name                = var.project_name
  environment                 = var.environment
  domain_name                 = var.domain_name
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  bucket_arn                  = module.s3.bucket_arn
  certificate_arn             = module.acm.certificate_arn
  origin_id                   = local.origin_id
  price_class                 = var.price_class
  kms_key_arn                 = module.s3.kms_key_arn
  kms_key_id                  = module.s3.kms_key_id
  logging_bucket_domain_name  = module.logging.bucket_domain_name
  tags                        = var.tags
}


# MONITORING MODULE
#
# CloudWatch alarms (CloudFront error rate, WAF blocked
# requests) + SNS email notifications.


module "monitoring" {

  source = "../../modules/monitoring"

  providers = {
    aws.virginia = aws.virginia
  }

  project_name               = var.project_name
  environment                = var.environment
  notification_email         = var.notification_email
  cloudfront_distribution_id = module.cloudfront.distribution_id
  waf_metric_name            = module.cloudfront.waf_metric_name

  tags = var.tags

}


# S3 BUCKET POLICY
#
# Allows ONLY the CloudFront Distribution
# to access objects inside the private bucket.


resource "aws_s3_bucket_policy" "website_bucket_policy" {

  bucket = module.s3.bucket_id

  policy = module.cloudfront.bucket_policy

}

# ROUTE53 MODULE
#
# Creates:
# Alias A Record
#
# www.sandtongridtech.com
#          │
#          ▼
#     CloudFront


module "route53" {

  source = "../../modules/route53"

  hosted_zone_id = var.hosted_zone_id

  domain_name = var.domain_name

  cloudfront_domain_name = module.cloudfront.distribution_domain_name

  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id

}


# WEBSITE DEPLOYMENT MODULE
#
# Uploads all files from the website directory to the
# private S3 bucket.


module "website_deployment" {

  source = "../../modules/website_deployment"

  bucket_name = module.s3.bucket_id

  website_directory = "${path.root}/../../website"

}
###############################################################
# GitHub Actions OIDC Module
#
# Creates the IAM Role that GitHub Actions will assume using
# OpenID Connect (OIDC). This eliminates the need for long-lived
# AWS Access Keys in GitHub Secrets.
###############################################################

module "github_oidc" {
  source = "../../modules/github_oidc"

  environment = var.environment

  #############################################################
  # GitHub Repository Information
  #############################################################

  github_owner      = var.github_owner
  github_repository = var.github_repository

  # The OIDC provider is an AWS-account-wide singleton — prod
  # creates it, this environment just looks it up.
  create_oidc_provider = false

  #############################################################
  # IAM Role Name
  #############################################################

  role_name = "${replace(var.project_name, " ", "-")}-github-actions-${var.environment}"

}

#########################################################
# GitHub Actions IAM Policy
#
# Creates the least-privilege IAM policy used by the
# GitHub Actions OIDC role for Terraform deployments.
#########################################################

module "github_oidc_policy" {
  source = "../../modules/github_oidc_policy"

  role_name    = module.github_oidc.role_name
  project_name = var.project_name
  environment  = var.environment

  website_bucket_name        = module.s3.bucket_name
  terraform_state_bucket     = var.terraform_state_bucket_name
  lock_table_name            = var.terraform_lock_table_name
  cloudfront_distribution_id = module.cloudfront.distribution_id
  hosted_zone_id             = var.hosted_zone_id
  kms_key_arn                = module.s3.kms_key_arn

  tags = var.tags
}

#########################################################
# Attach GitHub Actions Policy
#
# Attaches the custom IAM policy to the GitHub Actions
# OIDC role.
#########################################################

resource "aws_iam_role_policy_attachment" "github_actions_policy" {
  for_each = module.github_oidc_policy.policy_arns

  role       = module.github_oidc.role_name
  policy_arn = each.value
}




###############################################################
# Terraform Backend Infrastructure
#
# NOT created here. The S3 state bucket + lock table are an
# account-wide shared resource, bootstrapped once by
# environments/prod (see prod/main.tf). This environment's
# backend "s3" block (versions.tf) just points at that existing
# bucket under its own state key — it doesn't need to (and must
# not) also try to create it.
###############################################################
