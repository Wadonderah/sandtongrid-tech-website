
# WEBSITE DEPLOYMENT OUTPUTS
#
# Purpose:
# Exposes information about the files discovered and uploaded
# to the S3 bucket.


output "website_files" {

  description = "All discovered website files."

  value = local.website_files

}
