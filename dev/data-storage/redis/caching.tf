#
# Caching tier for NextCloud
#

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
  region = "eu-central-1"
  bucket = "nextcloud-terraform-test"
  key = "dev/network_state.tfstate"
 }
}
resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "nextcloud-caching"
  engine               = "redis"
  node_type            = "cache.t2.small"
  port                 = 6379
  num_cache_nodes      = "${var.caching_nodes_number}"
  apply_immediately    = true
  subnet_group_name    = "${data.terraform_remote_state.vpc.elasticache_subnet_group}"
  parameter_group_name = "default.redis3.2"
}
