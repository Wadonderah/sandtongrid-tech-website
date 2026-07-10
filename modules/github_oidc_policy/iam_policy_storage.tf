###############################################################
# GitHub Actions IAM Policy — Storage & Encryption
#
# Split out from a single combined policy because AWS caps a
# managed policy at 6144 characters — this project's full
# permission set doesn't fit in one. Grouped by function so each
# piece stays independently readable. All ARNs come from
# variables/locals — nothing here is hardcoded.
###############################################################

data "aws_iam_policy_document" "github_actions_storage" {

  #############################################################
  # S3 — Website Bucket
  #############################################################

  statement {
    sid    = "S3WebsiteBucketManagement"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:DeleteBucketTagging",
      "s3:GetBucketEncryption",
      "s3:PutBucketEncryption",
      "s3:GetBucketOwnershipControls",
      "s3:PutBucketOwnershipControls",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:GetBucketWebsite",
      "s3:PutBucketWebsite",
      "s3:DeleteBucketWebsite",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketCors",
      "s3:PutBucketCors",
      "s3:DeleteBucketCors",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload"
    ]

    resources = [
      local.website_bucket_arn,
      local.website_bucket_objects_arn
    ]
  }

  #############################################################
  # S3 — Terraform State Bucket
  #############################################################

  statement {
    sid    = "S3TerraformStateAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:GetBucketEncryption",
      "s3:PutBucketEncryption",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration"
    ]

    resources = [
      local.terraform_bucket_arn,
      local.terraform_bucket_objects_arn
    ]
  }

  #############################################################
  # S3 — CloudFront Access Log Bucket
  #############################################################

  statement {
    sid    = "S3LogsBucketManagement"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketOwnershipControls",
      "s3:PutBucketOwnershipControls",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketEncryption",
      "s3:PutBucketEncryption",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      local.logs_bucket_arn_prefix,
      "${local.logs_bucket_arn_prefix}/*"
    ]
  }

  #############################################################
  # DynamoDB — State Lock Table
  #############################################################

  statement {
    sid    = "DynamoDBLockAccess"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:DescribeTable",
      "dynamodb:ListTagsOfResource",
      "dynamodb:TagResource",
      "dynamodb:UntagResource"
    ]

    resources = [
      local.dynamodb_table_arn
    ]
  }

  #############################################################
  # KMS — Origin Bucket Encryption Key
  #############################################################

  statement {
    sid    = "KMSKeyUsage"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:PutKeyPolicy"
    ]

    resources = [
      local.kms_key_arn
    ]
  }
}
