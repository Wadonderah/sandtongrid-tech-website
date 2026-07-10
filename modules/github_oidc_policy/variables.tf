###############################################################
# Project Information
###############################################################

variable "project_name" {

  description = "Project name."

  type = string

}

variable "environment" {

  description = "Deployment environment (e.g. prod, dev, stage)."

  type = string

}

###############################################################
# GitHub Actions IAM Role
###############################################################

variable "role_name" {

  description = "GitHub Actions IAM Role."

  type = string

}

###############################################################
# Website Bucket
###############################################################

variable "website_bucket_name" {

  description = "Website bucket."

  type = string

}

###############################################################
# Terraform Backend Bucket
###############################################################

variable "terraform_state_bucket" {

  description = "Terraform backend bucket."

  type = string

}

###############################################################
# DynamoDB Lock Table
###############################################################

variable "lock_table_name" {

  description = "Terraform lock table."

  type = string

}

###############################################################
# CloudFront Distribution ID
###############################################################

variable "cloudfront_distribution_id" {

  description = "CloudFront Distribution ID."

  type = string

}

###############################################################
# Route53 Hosted Zone
###############################################################

variable "hosted_zone_id" {

  description = "Route53 Hosted Zone."

  type = string

}

###############################################################
# KMS Key (origin bucket encryption)
###############################################################

variable "kms_key_arn" {

  description = "ARN of the KMS key encrypting the website bucket."

  type = string

}

###############################################################
# Tags
###############################################################

variable "tags" {

  description = "Common tags."

  type = map(string)

}