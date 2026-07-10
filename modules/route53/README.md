<!-- BEGIN_TF_DOCS -->


## Usage

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.website_alias_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#input\_cloudfront\_domain\_name) | CloudFront domain name. | `string` | n/a | yes |
| <a name="input_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#input\_cloudfront\_hosted\_zone\_id) | CloudFront Hosted Zone ID. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Website domain. | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route53 Hosted Zone ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_website_record_name"></a> [website\_record\_name](#output\_website\_record\_name) | Website Alias Record |
<!-- END_TF_DOCS -->