
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }

}


provider "aws" {
  alias  = "virginia"
  region = var.acm_region

  default_tags {
    tags = var.tags
  }

}