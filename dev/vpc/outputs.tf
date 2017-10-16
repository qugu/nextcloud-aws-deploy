output "vpc_name" {
  value = "${aws_vpc.default.id}"
  description = "The VPC ID"
}
output "subnet_name" {
  value = "${aws_subnet.default.id}"
  description = "The subnet ID"
}
