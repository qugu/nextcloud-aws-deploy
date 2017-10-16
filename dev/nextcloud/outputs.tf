#output "elb_address" {
#  value = "${aws_elb.nextcloud-external-lb.dns_name}"
#}
output "redis_address" {
  value = "aws_elasticache_cluster.redis.cache_nodes.0.address"
}
output "redis_port" {
  value = "aws_elasticache_cluster.redis.cache_nodes.0.port"
}

