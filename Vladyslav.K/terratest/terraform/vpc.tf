# ################################################################################
# # VPC Module
# ################################################################################

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = var.vpc_name
#   cidr = "10.255.0.0/16"

#   azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
#   # private_subnets = ["10.255.1.0/24", "10.255.2.0/24", "10.255.3.0/24"]
#   public_subnets = ["10.255.101.0/24", "10.255.102.0/24", "10.255.103.0/24"]

#   enable_ipv6          = false
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     Name = "overridden-name-public"
#   }

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#   }

#   vpc_tags = {
#     Name = "Geocitizen VPC"
#   }
# }
