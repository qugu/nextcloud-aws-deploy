# Describe remote state here
iresource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "terraform_getting_started_guide_qugu"
  acl    = "private"
}
