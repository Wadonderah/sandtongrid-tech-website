###############################################################
# CloudFront Access Log Bucket
#
# CloudFront's classic (v1) standard logging still delivers via
# the legacy log-delivery ACL mechanism, so this bucket needs
# ACLs enabled (Object Ownership: BucketOwnerPreferred) and a
# grant to the AWS log delivery canonical user — this cannot be
# done through a bucket policy alone.
#
# Logs must use SSE-S3, not SSE-KMS — CloudFront's log delivery
# service cannot write to a bucket encrypted with a customer
# managed KMS key.
###############################################################

resource "random_id" "logs_suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "cloudfront_logs" {

  bucket = "${lower(replace(var.project_name, " ", "-"))}-${var.environment}-cf-logs-${random_id.logs_suffix.hex}"

  tags = merge(var.tags, {
    Name    = "${replace(var.project_name, " ", "-")}-${var.environment}-cf-logs"
    Purpose = "CloudFront Access Logs"
  })
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# AWS's fixed canonical user ID for the CloudFront/ELB log
# delivery service — this is a constant published by AWS, not a
# project-specific value, so it's safe as a literal here.
locals {
  aws_log_delivery_canonical_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
}

resource "aws_s3_bucket_acl" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  depends_on = [aws_s3_bucket_ownership_controls.cloudfront_logs]

  access_control_policy {

    owner {
      id = data.aws_canonical_user_id.current.id
    }

    grant {
      grantee {
        type = "CanonicalUser"
        id   = data.aws_canonical_user_id.current.id
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        type = "CanonicalUser"
        id   = local.aws_log_delivery_canonical_id
      }
      permission = "FULL_CONTROL"
    }
  }
}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = var.log_retention_days
    }
  }
}
