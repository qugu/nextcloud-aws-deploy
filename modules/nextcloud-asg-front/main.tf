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
  
  ami                    = "${lookup(var.amis, var.region)}"
  instance_type          = "${var.aws_instance_type["test"]}"
  key_name               = "${aws_key_pair.auth.id}"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${module.vpc.public_subnets[0]}"
  depends_on = ["aws_efs_file_system.nextcloud-fs"]
  depends_on = ["aws_subnet.default"]
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


