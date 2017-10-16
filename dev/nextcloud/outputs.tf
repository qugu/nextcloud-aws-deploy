output "elb_address" {
  value = "${module.nextcloud-asg-front.elb_public_dns}"
}
output "elasticache_subnets" {
  value = "${module.vpc.elasticache_subnets}"  
}

