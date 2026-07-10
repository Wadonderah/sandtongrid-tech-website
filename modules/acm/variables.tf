# Domain Name

variable "domain_name" {
  description = "Primary website domain."
  type        = string

}

# Route53 Hosted Zone ID

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID."
  type        = string

}

# Common Tags

variable "tags" {
  description = "Tags applied to AWS resources."
  type        = map(string)

}
