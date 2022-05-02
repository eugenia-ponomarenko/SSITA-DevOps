include {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/autoscaling/aws//?version=6.3.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "sg_instances" {
  config_path = "../sg_instances"
}

dependency "data" {
  config_path = "../data"
}

dependencies {
  paths = ["../vpc", "../sg_instances", "../data", "../alb", "../ec2_instance"]
}

locals {
  environment           = "dev"
  keypair_name          = "ss_geocit"
  instance_shape        = "t3.micro"
  node_exporter_VERSION = "1.3.1"
}

inputs = {
  name                      = "geocitizen-asg-${local.environment}"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = dependency.vpc.outputs.public_subnets
  key_name                  = local.keypair_name
  target_group_arns         = dependency.alb.outputs.target_group_arns

  # Launch template
  launch_template_name            = "geocit-asg-launch-template-${local.environment}"
  launch_template_description     = "Launch template geocitizen"
  launch_template_use_name_prefix = true
  update_default_version          = true
  security_groups                 = [dependency.sg_instances.outputs.security_group_id]
  image_id                        = dependency.data.outputs.latest_ubuntu_ami_id
  instance_type                   = local.instance_shape
  user_data = base64encode(templatefile("./init_web.tftpl", {
    docker_password = get_env("nexus_docker_password")
    VERSION         = local.node_exporter_VERSION
    }
  ))

  credit_specification = {
    cpu_credits = "standard"
  }
  scaling_policies = {
    avg-cpu-policy-greater-than-80 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 500
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 80.0
      }
    }
  }
  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance-${local.environment}" }
    }
  ]

  tags = {
    Environment = local.environment
  }
}
