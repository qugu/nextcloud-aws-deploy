#
# Creating a MariaDB SQL resource in RDS. Main instance and read replica.
#

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
  region = "eu-central-1"
  bucket = "nextcloud-terraform-test"
  key = "dev/network_state.tfstate"
 }
}


resource "aws_db_instance" "nextcloud_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.0.24"
  instance_class       = "db.t2.micro"
  name                 = "nextcloud${var.environment}"
  username             = "nextcloud"
  password             = "supersecret"
  db_subnet_group_name = "${data.terraform_remote_state.vpc.database_subnets[0]}"
  multi_az             = "false"
#  parameter_group_name = "default.mysql5.6"
}
