
# Bucket Name

variable "bucket_name" {

  description = "Name of the Amazon S3 bucket."

  type = string

}


# Common Tags

variable "tags" {

  description = "Tags applied to all AWS resources."

  type = map(string)

}
