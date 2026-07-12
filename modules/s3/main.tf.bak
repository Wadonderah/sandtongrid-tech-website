
# S3 MODULE
#
# Purpose:
# Creates a secure private Amazon S3 bucket that stores the
# static website files.
#
# This bucket is NOT publicly accessible.
# CloudFront will be the only service allowed to access it
# using Origin Access Control (OAC).


###############################################################
# Create the S3 Bucket
###############################################################
resource "aws_s3_bucket" "website_bucket" {

  bucket = var.bucket_name

  tags = var.tags

}



# Enable Bucket Versioning
#
# Keeps multiple versions of files.
# Useful for rollback and protection against accidental deletion.

resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

}


# Enable Server Side Encryption
#
# Encrypts every object stored inside the bucket using
# Amazon S3 managed encryption (AES256).

resource "aws_s3_bucket_server_side_encryption_configuration" "website_bucket_encryption" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_website_key.arn
    }
  }

}

# Bucket Ownership Controls
#
# Ensures uploaded objects belong to the bucket owner.


resource "aws_s3_bucket_ownership_controls" "website_bucket_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }

}


# Block ALL Public Access
#
# Since CloudFront will be serving the website,
# the bucket must remain completely private.


resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}








# KMS Key for S3 Website Bucket Encryption
resource "aws_kms_key" "s3_website_key" {
  description             = "KMS key for website bucket"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "s3_website_key" {
  # KMS aliases are unique per account+region, and this module is
  # instantiated once per environment — derive the alias from the
  # (already environment-unique) bucket name rather than a fixed
  # literal, so dev/staging/prod never collide.
  name          = "alias/${replace(var.bucket_name, ".", "-")}-key"
  target_key_id = aws_kms_key.s3_website_key.key_id
}
