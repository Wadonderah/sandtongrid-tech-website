###############################################################
# ROUTE 53 MODULE
#
# Purpose:
# Creates an Alias A Record that points the custom domain
# to the CloudFront Distribution.
#


###############################################################
# Alias Record
###############################################################

resource "aws_route53_record" "website_alias_record" {

  zone_id = var.hosted_zone_id

  name = var.domain_name

  type = "A"

  alias {

    name = var.cloudfront_domain_name

    zone_id = var.cloudfront_hosted_zone_id

    evaluate_target_health = false

  }

}
