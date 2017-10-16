variable "ec2_ami" {
  description = "EC2 AMI"
}
variable "ec2_region" {
  description = "Region of the EC2 instance (not AZ!)"
}
variable "ec2_instance_type" {
  description = "Instance type for the EC2 (i.e t2.micro)"
}
variable "ec2_vpc_sec_group" {
  description = "VPC security group for EC2 instances"
}
variable "ec2_vpc_subnet_id" {
  description = "VPC subnet ID in which to place EC2 instances"
}
variable "ec2_ssh_key_name" {
  description = "SSH Key name for EC2 instances" 
}
variable "elb_vpc_security_group" {
  description = "VPC security group for the ELB"
}
variable "elb_vpc_subnets" {
  description = "VPC subnets for the ELB"
}
