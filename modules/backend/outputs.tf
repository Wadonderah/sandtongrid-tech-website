###############################################################
# Backend Module Outputs
#
# Exposes backend resource information for use by
# higher-level Terraform configurations.
###############################################################

###############################################################
# Backend Bucket Name
###############################################################

output "bucket_name" {

  description = "Terraform backend S3 bucket name."

  value = aws_s3_bucket.terraform_state.id

}

###############################################################
# Backend Bucket ARN
###############################################################

output "bucket_arn" {

  description = "Terraform backend bucket ARN."

  value = aws_s3_bucket.terraform_state.arn

}

###############################################################
# DynamoDB Lock Table Name
###############################################################

output "dynamodb_table_name" {

  description = "Terraform state lock table name."

  value = aws_dynamodb_table.terraform_lock.name

}

###############################################################
# DynamoDB Lock Table ARN
###############################################################

output "dynamodb_table_arn" {

  description = "Terraform lock table ARN."

  value = aws_dynamodb_table.terraform_lock.arn

}


