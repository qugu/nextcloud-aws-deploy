# nextcloud-aws-deploy
Terraform and Ansible configurations to roll-out a mid-size Nextcloud deployment in AWS
(https://docs.nextcloud.com/server/11/admin_manual/installation/deployment_recommendations.html#mid-sized-enterprises)

This is a personal assessment project. Some hard requirements and stuff to think about:

- [] Multiple environments (test/dev/prod)
- [] Must support EC2, RDS, ELB, Security Groups, S3, CloudWatch Alerts
- [x] Modular structure for everything possible
- [x] File/directory layout best practices
- [x] Secrets management made wisely
- [] Add/remove components 1-by-1
- [x] Storing state remotely (remote state)
- [x] Must support terraform outputs

Some Ansible requirements:

- [] AWS as Ansible inventory
- [] Conflict resolution? Application deployment? 
- [] How to test code? How to rollback?
- [] File/directory layout best practices

This project is under development. Alpha stage, don't run it, bro!

In the end we should get a completely working NextCloud deployment.

Usage:
1. Create a keypair with ssh-keygen on Linux.
2. Edit `init/backend.tf` and comment out `terraform {}` block. Rename bucket in `bucket =` to a unique value.
3. Run terraform specifying the desired keypair name in AWS and the path to your new public key. In example:
$ terraform plan -var 'key_name=terraform-nextcloud-keypair' -var 'public_key_path=~/.ssh/terraform-nextcloud-rsa.pub' -out "nx.plan"
$ terraform apply "nx-plan.plan"
4. Uncomment change done in step 2 to enable a remote backend in AWS S3.
