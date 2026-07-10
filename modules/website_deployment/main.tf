
# WEBSITE DEPLOYMENT MODULE
#
# Purpose:
# Automatically uploads every file contained inside
# the website directory into Amazon S3.
#
# This module is reusable for any static website.



# Discover every file inside the website directory.


locals {


  # List every file under the website directory.


  website_files = fileset(var.website_directory, "**")


  # Mapping of file extensions to MIME types.
  #
  # This ensures browsers correctly interpret uploaded files.


  mime_types = {

    html = "text/html"

    css = "text/css"

    js = "application/javascript"

    json = "application/json"

    png = "image/png"

    jpg = "image/jpeg"

    jpeg = "image/jpeg"

    svg = "image/svg+xml"

    webp = "image/webp"

    ico = "image/x-icon"

    gif = "image/gif"

    txt = "text/plain"

    pdf = "application/pdf"

    xml = "application/xml"

    webmanifest = "application/manifest+json"

  }

}


# Upload Website Files
#
# Every file found inside the website folder is uploaded
# automatically while preserving its folder structure.


resource "aws_s3_object" "website_files" {

  for_each = toset(local.website_files)

  bucket = var.bucket_name

  key = each.value

  source = "${var.website_directory}/${each.value}"


  # Upload changed files only.


  etag = filemd5("${var.website_directory}/${each.value}")


  # Automatically determine the correct MIME type.


  content_type = lookup(
    local.mime_types,
    reverse(split(".", each.value))[0],
    "application/octet-stream"
  )

}
