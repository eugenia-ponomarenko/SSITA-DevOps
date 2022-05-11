include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//?version=3.14.0"
}

locals {
  aws_region                = "eu-north-1"
  cird_block                = "10.255.0.0/16"
  environment               = "dev"
  public_subnet_cidr_blocks = ["10.255.101.0/24", "10.255.102.0/24", "10.255.103.0/24"]
}

inputs = {
  name                 = "Geocitizen-VPC-${local.environment}"
  cidr                 = local.cird_block
  azs                  = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  public_subnets       = local.public_subnet_cidr_blocks
  enable_ipv6          = false
  enable_dns_hostnames = true
  public_subnet_tags = {
    Name = "Public-Subnet ${local.environment}"
  }
  tags = {
    Environment = local.environment
  }
  vpc_tags = {
    Name = "Geocitizen VPC: ${local.environment}"
  }
}

