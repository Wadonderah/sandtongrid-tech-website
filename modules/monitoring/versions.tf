terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"

      # CloudFront and CLOUDFRONT-scoped WAFv2 metrics are only
      # published to CloudWatch in us-east-1, regardless of the
      # distribution's home region. The root module passes this
      # alias in explicitly, same pattern as modules/cloudfront.
      configuration_aliases = [
        aws.virginia
      ]
    }
  }
}
