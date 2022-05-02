include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws//?version=4.9.0"
}

locals {
  environment = "prod"
}

inputs = {
  name        = "Geocitizen-DB-${local.environment}"
  description = "Security group for Geocitizen DB-${local.environment}"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_cidr_blocks = dependency.vpc.outputs.public_subnets_cidr_blocks
  ingress_rules       = ["postgresql-tcp"]
  egress_rules        = ["all-all"]
}

