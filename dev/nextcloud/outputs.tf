output "elb_address" {
  value = "${aws_elb.nextcloud-external-lb.dns_name}"
}
output "efs_dns_name" {
  value = "${data.aws_efs_file_system.by_id.dns_name}"
}

