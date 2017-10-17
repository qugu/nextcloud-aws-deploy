output "db_address" {
  value = "${aws_db_instance.nextcloud_db.address}"
}
output "db_port" {
  value = "${aws_db_instance.nextcloud_db.port}"
}
output "db_endpoint" {
 value = "${aws_db_instance.nextcloud_db.endpoint}"
}
output "db_status" {
  value = "${aws_db_instance.nextcloud_db.status}"
}
