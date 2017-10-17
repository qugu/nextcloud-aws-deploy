output "redis_address" {
  value = "${aws_elasticache_cluster.cache.cache_nodes}"
}
output "redis_port" {
  value = "${aws_elasticache_cluster.cache.cache_nodes.*.port}"
}
