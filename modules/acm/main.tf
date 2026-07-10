
#
# Purpose:
# Creates an SSL/TLS certificate for the custom domain.
#
# IMPORTANT:
# CloudFront ONLY supports ACM certificates created in
# us-east-1 (N. Virginia).
#
# The provider alias "aws.virginia" will be passed from
# the root module.

###############################################################
# Request ACM Certificate
###############################################################

resource "aws_acm_certificate" "website_certificate" {
  provider          = aws.virginia
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags

}


# Create DNS Validation Records
#
# ACM provides CNAME records that prove ownership of
# the domain.
#
# Terraform automatically creates them in Route53

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id         = var.hosted_zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
  allow_overwrite = true

}

# Validate Certificate
#
# Terraform waits until ACM verifies ownership
# before continuing.

resource "aws_acm_certificate_validation" "website_certificate_validation" {
  provider = aws.virginia

  certificate_arn = aws_acm_certificate.website_certificate.arn

  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation :
    record.fqdn
  ]
}
