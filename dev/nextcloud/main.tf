# Start off with using the VPC module to set up the network

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "nextcloud-vpc-test"
  cidr = "10.0.0.0/16"
  azs = ["eu-central-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets = ["10.0.11.0/24"]
  database_subnets    = ["10.0.21.0/24"]
  elasticache_subnets = ["10.0.31.0/24"] 
  create_database_subnet_group = false
  enable_nat_gateway = true

}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_efs_file_system" "nextcloud-fs" {
  creation_token = "nextcloud-fs"
}

module "nextcloud-asg-front" {
  source = "../../modules/nextcloud-asg-front"

  ec2_ami = "${lookup(var.amis, var.region)}"
  ec2_region = "${var.region}"
  ec2_instance_type = "${var.aws_instance_type["test"]}"
  ec2_vpc_sec_group = "${aws_security_group.default.id}"
  ec2_vpc_subnet_id = "${module.vpc.public_subnets[0]}"
  ec2_ssh_key_name = "${aws_key_pair.auth.id}"
  elb_vpc_security_group = "${aws_security_group.elb.id}"
  elb_vpc_subnets = "${module.vpc.public_subnets[0]}"
}

/*
# Let's do some bootstrapping here

resource "null_resource" "bootstrap" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join (",", module.nextcloud-asg-front.id)}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${module.nextcloud-asg-front.public_ip[0]}"
    user = "ubuntu"
    type = "ssh"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    inline = [
      "sudo apt -y update",
      "sudo apt -y install nginx",
      "sudo service nginx start",
    ]
  }
}
*/
