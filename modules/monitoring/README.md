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
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cloudfront_4xx_error_rate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cloudfront_5xx_error_rate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.waf_blocked_requests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.alerts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#input\_cloudfront\_distribution\_id) | CloudFront distribution ID to monitor. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment (e.g. prod, dev, stage). | `string` | n/a | yes |
| <a name="input_error_rate_threshold"></a> [error\_rate\_threshold](#input\_error\_rate\_threshold) | Percentage of 4xx/5xx responses that triggers an alarm. | `number` | `5` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address that receives CloudWatch alarm notifications via SNS. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name used for resource naming. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common resource tags. | `map(string)` | n/a | yes |
| <a name="input_waf_blocked_requests_threshold"></a> [waf\_blocked\_requests\_threshold](#input\_waf\_blocked\_requests\_threshold) | Number of WAF-blocked requests in one evaluation period that triggers an alarm. | `number` | `100` | no |
| <a name="input_waf_metric_name"></a> [waf\_metric\_name](#input\_waf\_metric\_name) | The WAFv2 visibility\_config metric\_name (NOT the Web ACL's name) — this is what CloudWatch's WebACL dimension actually contains. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic used for alarm notifications. |
<!-- END_TF_DOCS -->