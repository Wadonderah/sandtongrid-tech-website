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
| [aws_s3_object.website_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the destination S3 bucket. | `string` | n/a | yes |
| <a name="input_website_directory"></a> [website\_directory](#input\_website\_directory) | Path containing the website files. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_website_files"></a> [website\_files](#output\_website\_files) | All discovered website files. |
<!-- END_TF_DOCS -->