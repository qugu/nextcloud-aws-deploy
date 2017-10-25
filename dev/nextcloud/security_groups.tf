# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "terraform_nextcloud_${var.environment}_elb"
  description = "Used for the ELBs"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our security group to access the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_nextcloud_${var.environment}"
  description = "Used to access instances from various parts of the infra"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

