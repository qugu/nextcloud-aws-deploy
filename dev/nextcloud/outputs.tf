output "address" {
  value = "${aws_elb.nextcloud-external-lb.dns_name}"
}
