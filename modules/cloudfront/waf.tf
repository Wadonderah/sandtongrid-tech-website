###############################################################
# AWS WAF v2
#
# Project:
# Sandtongrid Technologies Website
#
# Purpose:
# Protects the CloudFront distribution against common web
# application attacks, bots, scanners and abusive traffic.
#
# Security Controls:
#
# • AWS Managed Common Rule Set
# • Known Bad Inputs
# • Amazon IP Reputation
# • Linux Rule Set
# • SQL Injection Protection
# • Anonymous IP Protection
# • Rate Limiting
#
# Scope:
# CLOUDFRONT
#
###############################################################

resource "aws_wafv2_web_acl" "cloudfront_waf" {

  provider = aws.virginia

  name = "${replace(var.project_name, " ", "-")}-${var.environment}-cloudfront-waf"

  description = "AWS WAF protecting the CloudFront distribution."

  scope = "CLOUDFRONT"

  #############################################################
  # Default Action
  #
  # Requests are allowed unless explicitly blocked by a rule.
  #############################################################

  default_action {

    allow {}

  }

  #############################################################
  # AWS Managed Common Rule Set
  #############################################################

  rule {

    name = "AWSManagedRulesCommonRuleSet"

    priority = 10

    override_action {

      none {}

    }

    statement {

      managed_rule_group_statement {

        vendor_name = "AWS"

        name = "AWSManagedRulesCommonRuleSet"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "CommonRuleSet"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # Known Bad Inputs
  #
  # Protects against Log4Shell and other malicious payloads.
  #############################################################

  rule {

    name = "AWSManagedRulesKnownBadInputsRuleSet"

    priority = 20

    override_action {

      none {}

    }

    statement {

      managed_rule_group_statement {

        vendor_name = "AWS"

        name = "AWSManagedRulesKnownBadInputsRuleSet"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "KnownBadInputs"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # Amazon IP Reputation List
  #
  # Blocks requests originating from IPs associated with
  # bots, malware, spam and reconnaissance activity.
  #############################################################

  rule {

    name = "AWSManagedRulesAmazonIpReputationList"

    priority = 30

    override_action {

      none {}

    }

    statement {

      managed_rule_group_statement {

        vendor_name = "AWS"

        name = "AWSManagedRulesAmazonIpReputationList"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "IPReputation"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # Linux Rule Set
  #
  # Protects against attacks targeting Linux based servers.
  #############################################################

  rule {

    name = "AWSManagedRulesLinuxRuleSet"

    priority = 40

    override_action {

      none {}

    }

    statement {

      managed_rule_group_statement {

        vendor_name = "AWS"

        name = "AWSManagedRulesLinuxRuleSet"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "LinuxRules"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # SQL Injection Protection
  #############################################################

  rule {

    name = "AWSManagedRulesSQLiRuleSet"

    priority = 50

    override_action {

      none {}

    }

    statement {

      managed_rule_group_statement {

        vendor_name = "AWS"

        name = "AWSManagedRulesSQLiRuleSet"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "SQLInjection"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # Anonymous IP Protection
  #
  # Helps block VPNs, TOR exit nodes and anonymous proxies.
  #############################################################

  rule {

    name = "AWSManagedRulesAnonymousIpList"

    priority = 60

    override_action {

      none {}

    }

    statement {

      managed_rule_group_statement {

        vendor_name = "AWS"

        name = "AWSManagedRulesAnonymousIpList"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "AnonymousIPs"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # Rate Limiting
  #
  # Blocks clients making more than 2,000 requests within
  # a five-minute period.
  #############################################################

  rule {

    name = "RateLimit"

    priority = 100

    action {

      block {}

    }

    statement {

      rate_based_statement {

        limit = 2000

        aggregate_key_type = "IP"

      }

    }

    visibility_config {

      cloudwatch_metrics_enabled = true

      metric_name = "RateLimit"

      sampled_requests_enabled = true

    }

  }

  #############################################################
  # Metrics
  #############################################################

  visibility_config {

    cloudwatch_metrics_enabled = true

    metric_name = "${replace(var.project_name, " ", "-")}-${var.environment}-cloudfront-waf"

    sampled_requests_enabled = true

  }

  #############################################################
  # Tags
  #############################################################

  tags = var.tags

}
