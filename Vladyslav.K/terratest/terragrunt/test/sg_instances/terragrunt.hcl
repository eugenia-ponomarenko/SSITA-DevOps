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
  environment = "test"
}

inputs = {
  name        = "Geocitizen-instances-${local.environment}"
  description = "Security group for Geocitizen web instances-${local.environment}"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-8080-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

