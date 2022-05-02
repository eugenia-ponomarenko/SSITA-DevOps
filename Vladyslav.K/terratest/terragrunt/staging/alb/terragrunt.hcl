include {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/alb/aws//?version=6.10.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg_web_lb" {
  config_path = "../sg_web_lb"
}

locals {
  environment = "staging"
}

inputs = {
  name = "geocit-alb-${local.environment}"

  load_balancer_type = "application"

  vpc_id          = dependency.vpc.outputs.vpc_id
  subnets         = dependency.vpc.outputs.public_subnets
  security_groups = [dependency.sg_web_lb.outputs.security_group_id]


  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      health_check = {
        path                = "/citizen/"
        interval            = 60
        port                = 8080
        protocol            = "HTTP"
        timeout             = 15
        healthy_threshold   = 2
        unhealthy_threshold = 9
        matcher             = "200-299"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = local.environment
  }
}
