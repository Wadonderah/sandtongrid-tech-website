###############################################################
# Local Values
###############################################################
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  #############################################################
  # S3 Buckets
  #############################################################
  website_bucket_arn           = "arn:aws:s3:::${var.website_bucket_name}"
  website_bucket_objects_arn   = "${local.website_bucket_arn}/*"
  terraform_bucket_arn         = "arn:aws:s3:::${var.terraform_state_bucket}"
  terraform_bucket_objects_arn = "${local.terraform_bucket_arn}/*"

  #############################################################
  # DynamoDB
  #############################################################
  dynamodb_table_arn = "arn:aws:dynamodb:${local.region}:${local.account_id}:table/${var.lock_table_name}"

  #############################################################
  # IAM
  #############################################################
  github_role_arn   = "arn:aws:iam::${local.account_id}:role/${var.role_name}"
  github_policy_arn = "arn:aws:iam::${local.account_id}:policy/${local.policy_base_name}"

  #############################################################
  # CloudFront
  #############################################################
  cloudfront_distribution_arn = "arn:aws:cloudfront::${local.account_id}:distribution/${var.cloudfront_distribution_id}"

  #############################################################
  # KMS
  #############################################################
  kms_key_arn = var.kms_key_arn

  #############################################################
  # Logging — CloudFront access log bucket (name has a random
  # suffix at creation time, so this is a prefix match, not an
  # exact ARN)
  #############################################################
  logs_bucket_arn_prefix = "arn:aws:s3:::${lower(replace(var.project_name, " ", "-"))}-${var.environment}-cf-logs-*"

  #############################################################
  # Monitoring — SNS + CloudWatch alarms live in us-east-1,
  # same as CloudFront/WAF metrics.
  #############################################################
  sns_topic_arn               = "arn:aws:sns:us-east-1:${local.account_id}:${replace(var.project_name, " ", "-")}-${var.environment}-alerts"
  cloudwatch_alarm_arn_prefix = "arn:aws:cloudwatch:us-east-1:${local.account_id}:alarm:${replace(var.project_name, " ", "-")}-${var.environment}-*"
}
