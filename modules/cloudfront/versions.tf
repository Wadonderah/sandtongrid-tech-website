###############################################################
# Terraform Configuration
#
# Project:
# Sandtongrid Technologies Website
#
# Purpose:
# Defines the Terraform version and required providers for
# the CloudFront module.
#
# Keeping provider requirements inside every reusable module
# ensures compatibility regardless of where the module is used.
###############################################################

terraform {

  #############################################################
  # Terraform Version
  #############################################################

  required_version = ">= 1.7.0"

  #############################################################
  # Required Providers
  #############################################################

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 5.0"

      # WAFv2 Web ACLs with scope = CLOUDFRONT must be created in
      # us-east-1 regardless of the distribution's home region.
      # The root module passes this alias in explicitly.
      configuration_aliases = [
        aws.virginia
      ]

    }

  }

}
