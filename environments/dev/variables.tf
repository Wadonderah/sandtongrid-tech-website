
variable "project_name" {
  description = "The name of the project"
  type        = string

}

variable "environment" {
  description = "The environment name"
  type        = string

}

variable "aws_region" {
  description = "The AWS region"
  type        = string

}

variable "acm_region" {
  description = "The ACM region"
  type        = string

}

variable "domain_name" {
  description = "The domain name"
  type        = string

}

variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string

}

variable "hosted_zone_id" {
  description = "The Hosted Zone ID"
  type        = string

}

variable "terraform_state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state."
  type        = string

}

variable "terraform_lock_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking."
  type        = string

}

variable "notification_email" {
  description = "Email address that receives CloudWatch alarm notifications (CloudFront errors, WAF blocks)."
  type        = string

}

variable "owner" {
  description = "The owner name"
  type        = string

}

variable "website_index_document" {
  description = "The index document for the website"
  type        = string
  default     = "index.html"

}

variable "website_error_document" {
  description = "The error document for the website"
  type        = string
  default     = "error.html"

}

variable "price_class" {

  description = "CloudFront Price Class"

  type = string

  default = "PriceClass_100"

}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)


}


# CloudFront Cache Policy


variable "cache_policy_id" {

  description = "AWS Managed Cache Policy ID."

  type = string

  default = "658327ea-f89d-4fab-a63d-7e88639e58f6"

}

variable "github_owner" {
  description = "GitHub organization or username that owns the repository."
  type        = string
  default     = "Wadonderah"
}

variable "github_repository" {
  description = "Name of the GitHub repository."
  type        = string
  default     = "sandtongrid-tech-website"
}
