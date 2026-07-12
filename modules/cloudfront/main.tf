###############################################################
# CloudFront Distribution
#
# Project:
# Sandtongrid Technologies Website
#
# Purpose
# -------
# Deploys a production-ready Amazon CloudFront Distribution
# that securely serves content from a private Amazon S3 bucket.
#
# Features
# --------
# ✓ Origin Access Control (OAC)
# ✓ AWS Managed Cache Policy
# ✓ AWS Managed Origin Request Policy
# ✓ AWS Managed Security Headers Policy
# ✓ HTTPS Enforcement
# ✓ IPv6 Enabled
# ✓ Compression Enabled
# ✓ AWS WAF Integration
# ✓ Geo Restriction Support
# ✓ Modern TLS
#
###############################################################

###############################################################
# AWS Managed Policies
#
# Using AWS managed policies avoids hardcoding IDs while
# automatically benefiting from AWS improvements.
###############################################################

data "aws_cloudfront_cache_policy" "managed_caching_optimized" {

  name = "Managed-CachingOptimized"

}

data "aws_cloudfront_origin_request_policy" "managed_cors_s3_origin" {

  name = "Managed-CORS-S3Origin"

}

data "aws_cloudfront_response_headers_policy" "managed_security_headers" {

  name = "Managed-SecurityHeadersPolicy"

}

###############################################################
# CloudFront Origin Access Control (OAC)
#
# OAC replaces the legacy Origin Access Identity (OAI)
# and is the AWS recommended method for securing S3 origins.
###############################################################

resource "aws_cloudfront_origin_access_control" "website_oac" {

  name = "${replace(var.project_name, " ", "-")}-${var.environment}-oac"

  description = "Origin Access Control for Sandtongrid Technologies"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"

  signing_protocol = "sigv4"

}

###############################################################
# CloudFront Distribution
###############################################################

resource "aws_cloudfront_distribution" "website_distribution" {

  enabled = true

  is_ipv6_enabled = true

  comment = "${var.project_name} CloudFront Distribution"

  default_root_object = "index.html"

  price_class = var.price_class

  aliases = [

    var.domain_name

  ]

  #############################################################
  # Origin Configuration
  #############################################################

  origin {

    domain_name = var.bucket_regional_domain_name

    origin_id = var.origin_id

    origin_access_control_id = aws_cloudfront_origin_access_control.website_oac.id

  }

  #############################################################
  # Default Cache Behaviour
  #############################################################

  default_cache_behavior {

    target_origin_id = var.origin_id

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [

      "GET",
      "HEAD",
      "OPTIONS"

    ]

    cached_methods = [

      "GET",
      "HEAD"

    ]

    compress = true

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed_cors_s3_origin.id

    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.managed_security_headers.id

  }

  #############################################################
  # SSL Certificate
  #############################################################

  viewer_certificate {

    acm_certificate_arn = var.certificate_arn

    ssl_support_method = "sni-only"

    minimum_protocol_version = "TLSv1.2_2021"

  }

  #############################################################
  # Geo Restrictions
  #
  # Adjust the list depending on where your customers are.
  #############################################################

  restrictions {

    geo_restriction {

      restriction_type = "whitelist"

      locations = [

        "KE",
        "UG",
        "TZ",
        "RW",
        "US",
        "GB"

      ]

    }

  }

  #############################################################
  # Custom Error Pages
  #############################################################

  custom_error_response {

    error_code = 403

    response_code = 403

    response_page_path = "/404.html"

  }

  custom_error_response {

    error_code = 404

    response_code = 404

    response_page_path = "/404.html"

  }

  #############################################################
  # Access Logging
  #############################################################

  logging_config {

    include_cookies = false

    bucket = var.logging_bucket_domain_name

    prefix = "cloudfront-logs/"

  }

  #############################################################
  # WAF Association
  #############################################################

  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn

  #############################################################
  # Resource Tags
  #############################################################

  tags = var.tags


  origin_group {
    origin_id = "origin-group-with-failover"
    failover_criteria {
      status_codes = [403, 404, 500, 502, 503, 504]
    }
    member {
      origin_id = "primary-origin"
    }
    member {
      origin_id = "secondary-origin"
    }
  }
}
