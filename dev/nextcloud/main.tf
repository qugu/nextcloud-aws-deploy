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


/* module "nextcloud-asg-front" {
  source = "../../modules/nextcloud-asg-front"
} */

resource "aws_instance" "web_server_1" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_instance_type["test"]}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.auth.id}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  depends_on = ["aws_efs_file_system.nextcloud-fs"]
  depends_on = ["aws_subnet.default"]

# Do bootstrapping with Ansible here
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }

}


resource "aws_instance" "web_server_2" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_instance_type["test"]}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.auth.id}"

  subnet_id = "${module.vpc.public_subnets[0]}"
  depends_on = ["aws_efs_file_system.nextcloud-fs"]
  depends_on = ["aws_subnet.default"]

# Do bootstrapping with Ansible here
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }

}


resource "aws_elb" "nextcloud-external-lb" {
  name               = "nextcloud-external-lb"
  subnets         = ["${module.vpc.public_subnets[0]}"]
  security_groups = ["${aws_security_group.elb.id}"]
  depends_on = [ "aws_instance.web_server_2", "aws_instance.web_server_1"]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  instances                   = [ "${aws_instance.web_server_2.id}", "${aws_instance.web_server_1.id}" ]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
