data "terraform_remote_state" "nextcloud-aws-state" {
  backend = "s3"
  config {
  region = "eu-central-1"
  bucket = "nextcloud-terraform-test"
  key = "dev/vpc_state.tfstate"
 }
}
resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "nextcloud-caching"
  engine               = "redis"
  node_type            = "cache.t2.small"
  port                 = 6379
  num_cache_nodes      = 1
  apply_immediately    = true
  subnet_group_name    = "${data.terraform_remote_state.nextcloud-aws-state.elasticache_subnets[0]}"
  parameter_group_name = "default.redis"
}
