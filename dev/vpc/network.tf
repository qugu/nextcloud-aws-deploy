#
# A wrapper template for the "vpc" module
# Let's define and initialize the network for our NextCloud deployment
#

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "nextcloud-vpc-${var.environment}"
  cidr = "10.0.0.0/16"
  azs = ["eu-central-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets = ["10.0.11.0/24"]
  database_subnets    = ["10.0.21.0/24"]
  elasticache_subnets = ["10.0.31.0/24"]
  create_database_subnet_group = false
  enable_nat_gateway = true

}
