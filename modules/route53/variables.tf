
# Hosted Zone ID


variable "hosted_zone_id" {

  description = "Route53 Hosted Zone ID."

  type = string

}


# Domain Name


variable "domain_name" {

  description = "Website domain."

  type = string

}


# CloudFront Domain


variable "cloudfront_domain_name" {

  description = "CloudFront domain name."

  type = string

}


# CloudFront Hosted Zone


variable "cloudfront_hosted_zone_id" {

  description = "CloudFront Hosted Zone ID."

  type = string

}
