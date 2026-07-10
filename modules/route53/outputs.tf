# Alias Record

output "website_record_name" {
  description = "Website Alias Record"
  value       = aws_route53_record.website_alias_record.fqdn

}
