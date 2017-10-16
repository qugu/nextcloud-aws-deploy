resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "nextcloud-caching"
  engine               = "redis"
  node_type            = "cache.t2.small"
  port                 = 6379
  num_cache_nodes      = 1
  apply_immediately    = true
  subnet_group_name    = "${terraform_remote_state.terraform.output.subnet_name}"
  # What is this actually for? 
  parameter_group_name = "default.redis"
}
