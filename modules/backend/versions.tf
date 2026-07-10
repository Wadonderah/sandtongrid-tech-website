###############################################################
# Terraform Backend Module
#
# This module provisions the infrastructure required to store
# Terraform remote state securely.
#
# Components created by this module:
#   • Amazon S3 Backend Bucket
#   • Bucket Versioning
#   • Server-Side Encryption
#   • Public Access Block
#   • DynamoDB State Lock Table
#
# Author: Sandtongrid Technologies
###############################################################

terraform {

  #############################################################
  # Minimum Terraform Version
  #############################################################

  required_version = ">= 1.13.0"

  #############################################################
  # Required Providers
  #############################################################

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}
