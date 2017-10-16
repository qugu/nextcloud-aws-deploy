provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/root/.aws/credentials"
}

# Setting up a repository for "remote state"

/* 
resource "aws_s3_bucket" "nextcloud-aws-state" {
  bucket = "nextcloud-terraform-test"
  acl    = "private"
  versioning {
    enabled = true
 }
}

*/

# Let's define a remote state. This block must be commented before you run the first block above to create a bucket.
terraform {
  backend "s3" {
    bucket = "nextcloud-terraform-test"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
} 
