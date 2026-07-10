# Certificate ARN
#
# CloudFront requires this ARN.

output "certificate_arn" {
  description = "ACM Certificate ARN."
  value       = aws_acm_certificate_validation.website_certificate_validation.certificate_arn


}



# Domain Name


output "domain_name" {

  description = "Domain name for the website."

  value = aws_acm_certificate.website_certificate.domain_name

}
