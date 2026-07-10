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
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.website_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.website_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_kms_key_policy.s3_website_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_wafv2_web_acl.cloudfront_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudfront_cache_policy.managed_caching_optimized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.managed_cors_s3_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_origin_request_policy) | data source |
| [aws_cloudfront_response_headers_policy.managed_security_headers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |
| [aws_iam_policy_document.cloudfront_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | ARN of the private S3 bucket used as the CloudFront origin. | `string` | n/a | yes |
| <a name="input_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#input\_bucket\_regional\_domain\_name) | Regional domain name of the private S3 bucket. | `string` | n/a | yes |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | AWS Managed Cache Policy ID. | `string` | `"658327ea-f89d-4fab-a63d-7e88639e58f6"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the ACM certificate used by CloudFront. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Fully qualified domain name served by CloudFront. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment (dev, stage, prod). | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key encrypting the origin S3 bucket. | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ID of the KMS key encrypting the origin S3 bucket. | `string` | n/a | yes |
| <a name="input_logging_bucket_domain_name"></a> [logging\_bucket\_domain\_name](#input\_logging\_bucket\_domain\_name) | Domain name of the S3 bucket CloudFront should deliver standard access logs to. | `string` | n/a | yes |
| <a name="input_origin_id"></a> [origin\_id](#input\_origin\_id) | Unique identifier for the CloudFront origin. | `string` | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | CloudFront edge locations used for content delivery. | `string` | `"PriceClass_100"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project used when naming AWS resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags applied to all AWS resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_policy"></a> [bucket\_policy](#output\_bucket\_policy) | IAM policy allowing CloudFront to read the S3 bucket. |
| <a name="output_distribution_arn"></a> [distribution\_arn](#output\_distribution\_arn) | CloudFront Distribution ARN. |
| <a name="output_distribution_domain_name"></a> [distribution\_domain\_name](#output\_distribution\_domain\_name) | CloudFront domain name. |
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | CloudFront Distribution ID. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | CloudFront Hosted Zone ID. |
| <a name="output_origin_access_control_id"></a> [origin\_access\_control\_id](#output\_origin\_access\_control\_id) | CloudFront Origin Access Control ID. |
| <a name="output_waf_metric_name"></a> [waf\_metric\_name](#output\_waf\_metric\_name) | The visibility\_config metric\_name — this is what CloudWatch's WebACL dimension actually contains, used by the monitoring module. |
| <a name="output_waf_web_acl_name"></a> [waf\_web\_acl\_name](#output\_waf\_web\_acl\_name) | Name of the CLOUDFRONT-scoped WAFv2 Web ACL. |
<!-- END_TF_DOCS -->