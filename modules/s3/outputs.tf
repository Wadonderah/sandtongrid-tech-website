
# Bucket ID


output "bucket_id" {

  description = "ID of the S3 bucket."

  value = aws_s3_bucket.website_bucket.id

}


# Bucket Name


output "bucket_name" {

  description = "Name of the S3 bucket."

  value = aws_s3_bucket.website_bucket.bucket

}


# Bucket ARN


output "bucket_arn" {

  description = "ARN of the S3 bucket."

  value = aws_s3_bucket.website_bucket.arn

}


# Regional Domain Name


output "bucket_regional_domain_name" {

  description = "Regional domain name of the S3 bucket."

  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name

}
output "website_bucket_domain_name" {
  description = "The domain name of the website bucket"
  value       = aws_s3_bucket.website_bucket.bucket_domain_name
}


# KMS Key ARN
#
# CloudFront needs this to be granted kms:Decrypt so it can
# read SSE-KMS encrypted objects when serving through OAC.

output "kms_key_arn" {

  description = "ARN of the KMS key encrypting the website bucket."

  value = aws_kms_key.s3_website_key.arn

}


# KMS Key ID


output "kms_key_id" {

  description = "ID of the KMS key encrypting the website bucket."

  value = aws_kms_key.s3_website_key.key_id

}
