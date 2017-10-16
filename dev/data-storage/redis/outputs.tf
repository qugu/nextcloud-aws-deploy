output "redis_address" {
  value = "aws_elasticache_cluster.redis.cache_nodes.*.address"
}
output "redis_port" {
  value = "aws_elasticache_cluster.redis.cache_nodes.*.port"
}
