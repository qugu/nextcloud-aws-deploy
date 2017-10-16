/* -------------------------
Create a launch configuration for auto-scaling and add instances there.
---------------------------- */

/*
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 2
  max_size = 10
  (...)
}

resource "aws_launch_configuration" "nextcloud-launch-configuration" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_instance_type["test"]}"
  (...)
}

*/

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name  = "nextcloud-cluster"
  count = 2
  
  ami                    = "${var.ec2_ami}"
  instance_type          = "${var.ec2_instance_type}"
  key_name               = "${var.ec2_ssh_key_name}"
  monitoring             = true
  vpc_security_group_ids = ["${var.ec2_vpc_sec_group}"]
  associate_public_ip_address = true
  subnet_id = "${var.ec2_vpc_subnet_id}"

}

resource "aws_elb" "nextcloud-external-lb" {
  name            = "nextcloud-external-lb"
  subnets         = ["${var.elb_vpc_subnets}"]
  security_groups = ["${var.elb_vpc_security_group}"]

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


