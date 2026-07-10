###############################################################
# CloudFront Module Variables
#
# Project:
# Sandtongrid Technologies Website
#
# Purpose:
# Defines all configurable input variables required by the
# CloudFront module.
#
# This module provisions:
# - CloudFront Distribution
# - Origin Access Control (OAC)
# - AWS WAF Association
# - Bucket Policy Document
#
# Following Terraform best practices:
# - Explicit typing
# - Variable validation
# - Descriptive documentation
# - No duplicate variables
###############################################################

###############################################################
# Project Information
###############################################################

variable "project_name" {

  description = "Name of the project used when naming AWS resources."

  type = string

}

variable "environment" {

  description = "Deployment environment (dev, stage, prod)."

  type = string

}

###############################################################
# Domain Configuration
###############################################################

variable "domain_name" {

  description = "Fully qualified domain name served by CloudFront."

  type = string

}

###############################################################
# Amazon S3 Origin
###############################################################

variable "bucket_arn" {

  description = "ARN of the private S3 bucket used as the CloudFront origin."

  type = string

}

variable "bucket_regional_domain_name" {

  description = "Regional domain name of the private S3 bucket."

  type = string

}

###############################################################
# ACM Certificate
#
# CloudFront requires certificates to exist in us-east-1.
###############################################################

variable "certificate_arn" {

  description = "ARN of the ACM certificate used by CloudFront."

  type = string

}

###############################################################
# CloudFront Origin
###############################################################

variable "origin_id" {

  description = "Unique identifier for the CloudFront origin."

  type = string

}

###############################################################
# KMS Key (SSE-KMS on the origin bucket)
#
# CloudFront must be explicitly granted kms:Decrypt on the key
# used to encrypt the origin bucket, or every request will fail
# with AccessDenied even though the S3 bucket policy is correct.
###############################################################

variable "kms_key_arn" {

  description = "ARN of the KMS key encrypting the origin S3 bucket."

  type = string

}

variable "kms_key_id" {

  description = "ID of the KMS key encrypting the origin S3 bucket."

  type = string

}

variable "logging_bucket_domain_name" {

  description = "Domain name of the S3 bucket CloudFront should deliver standard access logs to."

  type = string

}

###############################################################
# CloudFront Cache Policy
#
# Default:
# AWS Managed CachingOptimized Policy
###############################################################

variable "cache_policy_id" {

  description = "AWS Managed Cache Policy ID."

  type = string

  default = "658327ea-f89d-4fab-a63d-7e88639e58f6"

}

###############################################################
# CloudFront Price Class
###############################################################

variable "price_class" {

  description = "CloudFront edge locations used for content delivery."

  type = string

  default = "PriceClass_100"

  validation {

    condition = contains(
      [
        "PriceClass_100",
        "PriceClass_200",
        "PriceClass_All"
      ],
      var.price_class
    )

    error_message = "Price class must be PriceClass_100, PriceClass_200 or PriceClass_All."

  }

}

###############################################################
# Common Resource Tags
###############################################################

variable "tags" {

  description = "Common tags applied to all AWS resources."

  type = map(string)

}
