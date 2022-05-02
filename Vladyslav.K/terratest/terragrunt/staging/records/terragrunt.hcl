include {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/route53/aws//modules/records?version=2.6.0"
}

dependency "data" {
  config_path = "../data"
}

dependency "ec2_instance" {
  config_path = "../ec2_instance"
}

dependency "alb" {
  config_path = "../alb"
}

locals {
  environment = "staging"
}

inputs = {
  zone_id = dependency.data.outputs.domain
  records = jsonencode([
    {
      name            = "${local.environment}-dbgeo",
      allow_overwrite = true
      type            = "A"
      ttl             = 3600
      records = [
        dependency.ec2_instance.outputs.private_ip,
      ]
    },
    {
      name            = "${local.environment}-geocitizen"
      allow_overwrite = true
      type            = "A"
      alias = {
        name = dependency.alb.outputs.lb_dns_name
        #UUUHHHHHH
        zone_id = dependency.alb.outputs.lb_zone_id
      }
    }
  ])
}
