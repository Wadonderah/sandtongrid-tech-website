
# WEBSITE DEPLOYMENT MODULE VARIABLES
#
# Purpose:
# Receives the information required to upload the
# website files into the private S3 bucket.


###############################################################
# S3 Bucket Name
#
# The destination bucket where the website will be uploaded.
###############################################################

variable "bucket_name" {

  description = "Name of the destination S3 bucket."

  type = string

}


# Website Directory
#
# Absolute or relative path to the website folder.
#
# Example:
# ../../website


variable "website_directory" {

  description = "Path containing the website files."

  type = string

}
