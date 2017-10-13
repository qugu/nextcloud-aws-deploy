provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/root/.aws/creds"
}

# Setting up a repository for "remote state"

resource "aws_s3_bucket" "nextcloud-aws-state" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "nextcloud-terraform-test"
  acl    = "private"
}

# This block must be commented before you run the first block above to create a bucket.
terraform {
  backend "s3" {
    bucket = "nextcloud-terraform-test"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
} 
