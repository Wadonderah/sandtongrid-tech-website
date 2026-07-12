###############################################################
# Terraform Backend Configuration
###############################################################

# ------------------------------------------------------------------------------
# S3 Bucket for Terraform State
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    # No ACL-based access needed here — access is governed purely
    # by IAM policy, so ACLs stay fully disabled (current AWS
    # default/best practice, same pattern as modules/s3).
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}

# ------------------------------------------------------------------------------
# S3 Bucket Lifecycle Configuration
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    filter {}
    id     = "cleanup"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# ------------------------------------------------------------------------------
# Log Bucket for S3 Access Logging
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}-logs"

  tags = merge(var.tags, {
    Name = "${var.bucket_name}-logs"
  })
}

resource "aws_s3_bucket_ownership_controls" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    # log-delivery-write below is a canned ACL, which requires
    # ACLs to stay enabled on this bucket (unlike terraform_state
    # above) — AWS disables ACLs by default on new buckets, so
    # this has to be explicit.
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket]

  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

# Without this, log_bucket exists but nothing ever writes to it.
resource "aws_s3_bucket_logging" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "s3-access-logs/"
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    filter {}
    id     = "expire-logs"
    status = "Enabled"
    expiration {
      days = 90
    }
  }
}

# ------------------------------------------------------------------------------
# KMS Key for S3 State Bucket
# ------------------------------------------------------------------------------
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for Terraform state bucket"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow S3 Service"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_kms_alias" "s3_key" {
  name          = "alias/${replace(var.project_name, " ", "-")}-${var.environment}-terraform-state-key"
  target_key_id = aws_kms_key.s3_key.key_id
}

# ------------------------------------------------------------------------------
# KMS Key for DynamoDB
# ------------------------------------------------------------------------------
resource "aws_kms_key" "dynamodb_key" {
  description             = "KMS key for DynamoDB table encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow DynamoDB Service"
        Effect = "Allow"
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_kms_alias" "dynamodb_key" {
  name          = "alias/${replace(var.project_name, " ", "-")}-${var.environment}-dynamodb-key"
  target_key_id = aws_kms_key.dynamodb_key.key_id
}

# ------------------------------------------------------------------------------
# DynamoDB Table for State Locking
# ------------------------------------------------------------------------------
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = merge(var.tags, {
    Name = var.dynamodb_table_name
  })
}

# ------------------------------------------------------------------------------
# Data Sources
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}
