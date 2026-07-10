###############################################################
# CloudFront Outputs
#
# Exposes values required by:
#
# • Route53
# • S3 Bucket Policy
# • Root Module
#
###############################################################

###############################################################
# WAF Web ACL Name
###############################################################

output "waf_web_acl_name" {

  description = "Name of the CLOUDFRONT-scoped WAFv2 Web ACL."

  value = aws_wafv2_web_acl.cloudfront_waf.name

}

###############################################################
# WAF CloudWatch Metric Name
#
# NOT the same as the ACL's name above. WAFv2's CloudWatch
# "WebACL" dimension is populated from visibility_config's
# metric_name field, not the resource's name attribute — this is
# the value the monitoring module actually needs to match alarms
# against real published metrics.
###############################################################

output "waf_metric_name" {

  description = "The visibility_config metric_name — this is what CloudWatch's WebACL dimension actually contains, used by the monitoring module."

  value = "${replace(var.project_name, " ", "-")}-${var.environment}-cloudfront-waf"

}

###############################################################
# Distribution ID
###############################################################

output "distribution_id" {

  description = "CloudFront Distribution ID."

  value = aws_cloudfront_distribution.website_distribution.id

}

###############################################################
# Distribution ARN
###############################################################

output "distribution_arn" {

  description = "CloudFront Distribution ARN."

  value = aws_cloudfront_distribution.website_distribution.arn

}

###############################################################
# Distribution Domain Name
###############################################################

output "distribution_domain_name" {

  description = "CloudFront domain name."

  value = aws_cloudfront_distribution.website_distribution.domain_name

}

###############################################################
# CloudFront Hosted Zone ID
#
# Required by Route53 Alias Record
###############################################################

output "hosted_zone_id" {

  description = "CloudFront Hosted Zone ID."

  value = aws_cloudfront_distribution.website_distribution.hosted_zone_id

}

###############################################################
# Origin Access Control ID
###############################################################

output "origin_access_control_id" {

  description = "CloudFront Origin Access Control ID."

  value = aws_cloudfront_origin_access_control.website_oac.id

}

###############################################################
# Bucket Policy JSON
#
# Used by:
#
# aws_s3_bucket_policy
#
###############################################################

output "bucket_policy" {

  description = "IAM policy allowing CloudFront to read the S3 bucket."

  value = data.aws_iam_policy_document.cloudfront_bucket_policy.json

}

