# this section stores the terraform state for the s3 bucket in the terraform state bucket we created in step 1.
terraform {
  required_version = ">=0.12.8"
}

# this is for an aws specific provider(not gcp or azure)
provider "aws" {
  version = "<= 2.28"
  region  = "${var.region}"
  profile = "${var.profile}"
}

provider "template" {
  version = "~> 2.1"
}
