variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. prod, dev, stage)."
  type        = string
}

variable "notification_email" {
  description = "Email address that receives CloudWatch alarm notifications via SNS."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.notification_email))
    error_message = "notification_email must be a valid email address."
  }
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID to monitor."
  type        = string
}

variable "waf_metric_name" {
  description = "The WAFv2 visibility_config metric_name (NOT the Web ACL's name) — this is what CloudWatch's WebACL dimension actually contains."
  type        = string
}

variable "error_rate_threshold" {
  description = "Percentage of 4xx/5xx responses that triggers an alarm."
  type        = number
  default     = 5

  validation {
    condition     = var.error_rate_threshold > 0 && var.error_rate_threshold <= 100
    error_message = "error_rate_threshold must be between 0 and 100."
  }
}

variable "waf_blocked_requests_threshold" {
  description = "Number of WAF-blocked requests in one evaluation period that triggers an alarm."
  type        = number
  default     = 100
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
