# AWS region variable
variable "region" {
  description = "AWS region to launch servers"
  default = "eu-central-1"
}

# AWS machine images to region mapping
variable "amis" {
  type = "map"
  default = {
    "eu-central-1" = "ami-1e339e71"
  }
}

# AWS instance type to environment mapping
variable "aws_instance_type" {
  type = "map"
  default = {
     "test" = "t2.micro"
     "dev" = "t2.micro"
     "production" = "m4.large"
  }
}

# Public key path and name (down below)
variable "public_key_path" {
  description = <<PATH_DESC
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform-nextcloud-key.pub
PATH_DESC
  default = "~/.ssh/terraform-nextcloud-rsa.pub"
}

variable "private_key_path" {
  description = "Path to private key for instance bootstrapping"
  default = "~/.ssh/terraform-nextcloud-rsa"
}

variable "key_name" {
  description = <<KEY_NAME_DESC
Name of the keypair being created. Example: terraform-nextcloud-key
KEY_NAME_DESC
}
