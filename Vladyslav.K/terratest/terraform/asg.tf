# module "asg" {
#   source = "terraform-aws-modules/autoscaling/aws"

#   # Autoscaling group
#   name = "geocitizen-asg"

#   min_size                  = 1
#   max_size                  = 5
#   desired_capacity          = 4
#   wait_for_capacity_timeout = 0
#   health_check_type         = "EC2"
#   vpc_zone_identifier       = module.vpc.public_subnets
#   key_name                  = var.keypair_name
#   target_group_arns         = module.alb.target_group_arns


#   instance_refresh = {
#     strategy = "Rolling"
#     preferences = {
#       checkpoint_delay       = 600
#       checkpoint_percentages = [35, 70, 100]
#       instance_warmup        = 300
#       min_healthy_percentage = 50
#     }
#     triggers = ["tag"]
#   }

#   # Launch template
#   launch_template_name            = "geocit-asg-launch-template"
#   launch_template_description     = "Launch template geocitizen"
#   launch_template_use_name_prefix = true
#   update_default_version          = true
#   security_groups                 = [module.sg_instances.security_group_id]
#   image_id                        = data.aws_ami.ubuntu_latest.id
#   instance_type                   = var.instance_shape
#   ebs_optimized                   = true
#   enable_monitoring               = false
#   user_data = base64encode(templatefile("./init_web.tftpl", {
#     docker_password = var.nexus_docker_password
#     VERSION         = var.node_exporter_VERSION
#     }
#   ))

#   credit_specification = {
#     cpu_credits = "standard"
#   }
#   scaling_policies = {
#     my-policy = {
#       policy_type = "TargetTrackingScaling"
#       target_tracking_configuration = {
#         predefined_metric_specification = {
#           predefined_metric_type = "ASGAverageCPUUtilization"
#           resource_label         = "MyLabel"
#         }
#         target_value = 50.0
#       }
#     }
#   }

#   tag_specifications = [
#     {
#       resource_type = "instance"
#       tags          = { WhatAmI = "Instance" }
#     }
#   ]

#   tags = {
#     Environment = "dev"
#     Project     = "megasecret"
#   }
# }

