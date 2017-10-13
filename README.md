# nextcloud-aws-deploy
Terraform and Ansible configurations to roll-out a mid-size Nextcloud deployment in AWS
(https://docs.nextcloud.com/server/11/admin_manual/installation/deployment_recommendations.html#mid-sized-enterprises)

This is a personal assessment project. Some hard requirements and stuff to think about:

* Multiple environments (test/dev/prod)
* Must support EC2, RDS, ELB, Security Groups, S3, CloudWatch Alerts
* Modular structure for everything possible
* File/directory layout best practices
* Secrets management made wisely
* Add/remove components 1-by-1
* Storing state remotely (remote state)
* Must support terraform outputs

Some Ansible requirements:

* AWS as Ansible inventory
* Conflict resolution? Application deployment? 
* How to test code? How to rollback?
* File/directory layout best practices

This project is under development. Alpha stage, don't run it, bro!

Usage:
1. Create a keypair with ssh-keygen.
2. Run terraform specifying the desired keypair name in AWS and the path to your new public key. In example:
$ terraform plan -var 'key_name=terraform-nextcloud-keypair' -var 'public_key_path=~/.ssh/terraform-nextcloud-rsa.pub' -out "nx.plan"
$ terraform apply "nx-plan.plan"
