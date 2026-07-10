output "bucket_domain_name" {
  description = "Bucket domain name CloudFront should write access logs to."
  value       = aws_s3_bucket.cloudfront_logs.bucket_domain_name
}

output "bucket_arn" {
  description = "ARN of the CloudFront access log bucket."
  value       = aws_s3_bucket.cloudfront_logs.arn
}

output "bucket_id" {
  description = "ID of the CloudFront access log bucket."
  value       = aws_s3_bucket.cloudfront_logs.id
}
