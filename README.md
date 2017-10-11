# nextcloud-aws-deploy
Terraform and Ansible templates to roll-out a mid-size Nextcloud deployment in AWS

This project is under development. Alpha stage, doesn't work.

Some pointers:
- "common" is a directory for generic configuration files
- [dev|test|prod] specifies environment specific directories
- common/secrets.tfvars specifies a file with amazon credentials in format:
    # Authentication on AWS
    variable "access_key" = ""
    variable "secret_key"  = ""
