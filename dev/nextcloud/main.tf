provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_efs_file_system" "nextcloud-fs" {
  creation_token = "nextcloud-fs"
}

resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "terraform_getting_started_guide_qugu"
  acl    = "private"
}

resource "aws_instance" "web_server_1" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"

# Depends on ELB, EFS
  depends_on = ["aws_efs_file_system.nextcloud-fs"]
  #depends_on = ["aws_elb.nextcloud-external-lb"]

# Do bootstrapping with Ansible here
   provisioner "local-exec" {
   command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
   }
}

resource "aws_instance" "web_server_2" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
# Depends on ELB, EFS
  depends_on = ["aws_efs_file_system.nextcloud-fs"]
  #depends_on = ["aws_elb.nextcloud-external-lb"]
# Do bootstrapping with Ansible here
   provisioner "local-exec" {
   command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
   }
}

resource "aws_elb" "nextcloud-external-lb" {
  name               = "nextcloud-external-lb"
  availability_zones = ["${lookup(var.region)}"]

  depends_on = ["aws_instance.web_server_2"; "aws_instance.web_server_1"]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
    # ssl_certificate_id = "arn:aws:iam::000000000000:server-certificate/wu-tang.net"
  }

  instances                   = ["${aws_instance.web_server_1}; ${aws_instance.web_server_2}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

/* Here go the outputs */
output "ami" {
  value = "${lookup(var.amis, var.region)}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}
