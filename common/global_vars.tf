# Region variables
variable "region" {
  description = "AWS region to launch servers"
  default = "eu-central-1"
}

# AWS auth variables
variable "access_key" {}
variable "secret_key" {}

# AMI Definitions
variable "amis" {
  type = "map"
  default = {
    "eu-central-1" = "ami-1e339e71"
  }
}

# AWS instance type definition
variable "aws_instance_type" {
  type = "map"
  default = {
     "test" = "t2.micro"
     "production" = "m4.large"
  }
}

variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = <<KEY_NAME_DESC
Name of the keypair being created. Example: terraform-nextcloud-key
KEY_NAME_DESC
}
