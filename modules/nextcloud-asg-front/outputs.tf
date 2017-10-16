output "id" {
  description = "List if ID's of instances"
  value       = ["${module.ec2_cluster.id}"]
}
output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = ["${module.ec2_cluster.private_ip}"]
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = ["${module.ec2_cluster.public_ip}"]
}
output "elb_public_dns" {
  description = "The public DNS of the ELB"
  value = ["${aws_elb.nextcloud-external-lb.dns_name}"]
}
