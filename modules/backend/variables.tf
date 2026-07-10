###############################################################
# Backend S3 Bucket Name
#
# Name of the S3 bucket that stores the Terraform state.
###############################################################

variable "bucket_name" {

  description = "Terraform backend S3 bucket name."

  type = string

  validation {

    condition = length(var.bucket_name) > 3

    error_message = "Bucket name must contain at least 4 characters."

  }

}

###############################################################
# DynamoDB Table Name
#
# Table used for Terraform state locking.
###############################################################

variable "dynamodb_table_name" {

  description = "Terraform state lock table."

  type = string

  validation {

    condition = length(var.dynamodb_table_name) > 3

    error_message = "DynamoDB table name must contain at least 4 characters."

  }

}

###############################################################
# Project Name
###############################################################

variable "project_name" {

  description = "Project name."

  type = string

}

###############################################################
# Deployment Environment
###############################################################

variable "environment" {

  description = "Deployment environment."

  type = string

}

###############################################################
# Common Resource Tags
###############################################################

variable "tags" {

  description = "Common tags applied to all backend resources."

  type = map(string)

}
