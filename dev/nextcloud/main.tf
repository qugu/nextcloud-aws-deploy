# Attach data source for VPC, Caching toer and RDS so we can query the attributes for values

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
  region = "eu-central-1"
  bucket = "nextcloud-terraform-test"
  key = "dev/network_state.tfstate"
 }
}

data "terraform_remote_state" "database" {
  backend = "s3"
  config {
  region = "eu-central-1"
  bucket = "nextcloud-terraform-test"
  key = "dev/rds.tfstate"
 }
}

data "terraform_remote_state" "caching" {
  backend = "s3"
  config {
  region = "eu-central-1"
  bucket = "nextcloud-terraform-test"
  key = "dev/caching.tfstate"
 }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_efs_file_system" "nextcloud-fs" {
  creation_token = "nextcloud-fs"
}

data "aws_efs_file_system" "by_id" {
  file_system_id = "${aws_efs_file_system.nextcloud-fs.id}"
}

# Create the EC2 cluster already!

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name  = "nextcloud-cluster-${var.environment}"
  count = "${var.ec2_nodes_number}"

  ami                    = "${lookup(var.amis, var.region)}"
  instance_type          = "${var.aws_instance_type["test"]}"
  key_name               = "${var.key_name}"
  monitoring             = "true"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  associate_public_ip_address = "true"
  subnet_id = "${data.terraform_remote_state.vpc.public_subnets[0]}"

}

# Create a load balancer and attach it to the EC2 fleet

resource "aws_elb" "nextcloud-external-lb" {
  name            = "nextcloud-external-lb-${var.environment}"
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets[0]}"]
 # security_groups = ["${data.terraform_remote_state.vpc.default_security_group_id}"]
# Depend on the security group to be created from security_groups.tf file
  depends_on = ["aws_security_group.elb"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  instances                   = [ "${module.ec2_cluster.id}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

# Let's do some bootstrapping here

resource "null_resource" "bootstrap" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join (",", module.ec2_cluster.id)}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${element(module.ec2_cluster.public_ip, 0)}"
    user = "ubuntu"
    type = "ssh"
    private_key = "${file(var.private_key_path)}"
  }
  
#  provisioner "local-exec" {
#      command = "echo ${data.aws_efs_file_system.by_id.dns_name} >> filesystem_dns_name.txt"
#}
  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    inline = [
      "sudo apt -y update",
      "sudo apt -y install nginx nfs-common",
      "sudo service nginx start",
    ]
  }
}
