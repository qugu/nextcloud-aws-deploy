data "terraform_remote_state" "general" {
  backend = "s3"
  config {
    bucket = "nextcloud-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
