variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. prod, dev, stage)."
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudFront access logs before expiry."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days > 0
    error_message = "log_retention_days must be greater than 0."
  }
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
}
