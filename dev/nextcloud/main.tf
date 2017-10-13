/*
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
} */


resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_efs_file_system" "nextcloud-fs" {
  creation_token = "nextcloud-fs"
}

resource "aws_instance" "web_server_1" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_instance_type["test"]}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.auth.id}"

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"
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

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"
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
#  availability_zones = ["${lookup(var.amis, var.region)}"]
  subnets         = ["${aws_subnet.default.id}"]
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

/* Here go the outputs */

