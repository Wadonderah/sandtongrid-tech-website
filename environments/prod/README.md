<!-- BEGIN_TF_DOCS -->


## Usage

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.54 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.54 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ../../modules/acm | n/a |
| <a name="module_backend"></a> [backend](#module\_backend) | ../../modules/backend | n/a |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../../modules/cloudfront | n/a |
| <a name="module_github_oidc"></a> [github\_oidc](#module\_github\_oidc) | ../../modules/github_oidc | n/a |
| <a name="module_github_oidc_policy"></a> [github\_oidc\_policy](#module\_github\_oidc\_policy) | ../../modules/github_oidc_policy | n/a |
| <a name="module_logging"></a> [logging](#module\_logging) | ../../modules/logging | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ../../modules/monitoring | n/a |
| <a name="module_route53"></a> [route53](#module\_route53) | ../../modules/route53 | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ../../modules/s3 | n/a |
| <a name="module_website_deployment"></a> [website\_deployment](#module\_website\_deployment) | ../../modules/website_deployment | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.github_actions_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket_policy.website_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_region"></a> [acm\_region](#input\_acm\_region) | The ACM region | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The S3 bucket name | `string` | n/a | yes |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | AWS Managed Cache Policy ID. | `string` | `"658327ea-f89d-4fab-a63d-7e88639e58f6"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub organization or username that owns the repository. | `string` | `"Wadonderah"` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Name of the GitHub repository. | `string` | `"sandtongrid-tech-website"` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The Hosted Zone ID | `string` | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address that receives CloudWatch alarm notifications (CloudFront errors, WAF blocks). | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | The owner name | `string` | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | CloudFront Price Class | `string` | `"PriceClass_100"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |
| <a name="input_terraform_lock_table_name"></a> [terraform\_lock\_table\_name](#input\_terraform\_lock\_table\_name) | Name of the DynamoDB table used for Terraform state locking. | `string` | n/a | yes |
| <a name="input_terraform_state_bucket_name"></a> [terraform\_state\_bucket\_name](#input\_terraform\_state\_bucket\_name) | Name of the S3 bucket used for Terraform remote state. | `string` | n/a | yes |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | The error document for the website | `string` | `"error.html"` | no |
| <a name="input_website_index_document"></a> [website\_index\_document](#input\_website\_index\_document) | The index document for the website | `string` | `"index.html"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | s3 Bucket. |
| <a name="output_github_actions_role_arn"></a> [github\_actions\_role\_arn](#output\_github\_actions\_role\_arn) | IAM Role ARN for GitHub Actions. |
| <a name="output_region"></a> [region](#output\_region) | Deployment region. |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | Website domain. |
<!-- END_TF_DOCS -->