###############################################################
# CloudFront Bucket Policy
#
# Project:
# Sandtongrid Technologies Website
#
# Purpose:
# Generates the IAM policy document that allows ONLY the
# CloudFront Distribution (using Origin Access Control)
# to retrieve objects from the private S3 bucket.
#
# Security Benefits
# -----------------
# • S3 bucket remains completely private
# • Direct S3 access is denied
# • CloudFront becomes the only trusted principal
# • Prevents object enumeration
# • Follows AWS Security Best Practices
###############################################################

###############################################################
# Account Identity
#
# Needed to rebuild the "account owner" statement below, since
# attaching a new key policy REPLACES the key's existing policy
# wholesale rather than merging into it.
###############################################################

data "aws_caller_identity" "current" {}

###############################################################
# S3 Bucket Policy Document
###############################################################

data "aws_iam_policy_document" "cloudfront_bucket_policy" {

  #############################################################
  # Allow CloudFront to Read Objects
  #############################################################

  statement {

    sid = "AllowCloudFrontServicePrincipalReadOnly"

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "cloudfront.amazonaws.com"
      ]

    }

    actions = [

      "s3:GetObject"

    ]

    resources = [

      "${var.bucket_arn}/*"

    ]

    ###########################################################
    # Restrict access to ONLY this CloudFront Distribution
    ###########################################################

    condition {

      test = "StringEquals"

      variable = "AWS:SourceArn"

      values = [

        aws_cloudfront_distribution.website_distribution.arn

      ]

    }

  }

}

###############################################################
# KMS Key Policy — Grant CloudFront Decrypt
#
# Required whenever the origin S3 bucket uses SSE-KMS. Without
# this, CloudFront (via OAC) gets AccessDenied fetching objects
# even though the S3 bucket policy above is correct.
#
# This replaces the key's whole policy, so it also re-declares
# full admin access for the account root — otherwise the account
# would be locked out of managing its own key.
###############################################################

data "aws_iam_policy_document" "s3_kms_key_policy" {

  statement {

    sid = "EnableIAMUserPermissions"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    sid = "AllowCloudFrontServicePrincipalDecrypt"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]

    resources = [
      "*"
    ]

    condition {

      test = "StringEquals"

      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.website_distribution.arn
      ]

    }

  }

}

resource "aws_kms_key_policy" "s3_website_key_policy" {

  key_id = var.kms_key_id

  policy = data.aws_iam_policy_document.s3_kms_key_policy.json

}
