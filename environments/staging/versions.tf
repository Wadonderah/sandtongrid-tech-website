#############################################################
# Terraform Configuration
#
# Configures:
# - Required Terraform version
# - AWS provider version
# - Remote backend using S3
# - DynamoDB state locking
#############################################################

terraform {

  required_version = ">= 1.13.0"

  backend "s3" {
    bucket       = "sandtongrid-tech-terraform-state"
    key          = "staging/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

}