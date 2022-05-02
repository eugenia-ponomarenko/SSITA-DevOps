################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.vpc_name} - ${var.environment}"
  cidr                 = var.vpc_cidr_block
  azs                  = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  public_subnets       = ["10.255.101.0/24", "10.255.102.0/24", "10.255.103.0/24"]
  enable_ipv6          = false
  enable_dns_hostnames = true
  public_subnet_tags = {
    Name = "Public-Subnet ${var.environment}"
  }
  tags = {
    Environment = var.environment
  }
  vpc_tags = {
    Name = "Geocitizen VPC: ${var.environment}"
  }
}
################################################################################
# Security groups
################################################################################
module "sg_db" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Geocitizen-DB-${var.environment}"
  description = "Security group for Geocitizen DB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  ingress_rules       = ["postgresql-tcp"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
module "sg_web_lb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Geocitizen-WEB"
  description = "Security group for Geocitizen WEB LB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "sg_instances" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Geocitizen-instances"
  description = "Security group for Geocitizen web instances"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-8080-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}
################################################################################
# EC2
################################################################################

data "aws_ami" "amazon_linux_latest" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "ubuntu_latest" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
################################################################################
# ec2-instance Module
################################################################################
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Geocitizen-DB-${var.environment}"

  ami                         = data.aws_ami.amazon_linux_latest.id
  instance_type               = var.instance_shape
  key_name                    = var.keypair_name
  associate_public_ip_address = true

  vpc_security_group_ids = [module.sg_db.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data = templatefile("./init_db.tftpl", {
    docker_password = var.nexus_docker_password
    VERSION         = var.node_exporter_VERSION
    }
  )

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

################################################################################
# Auto Scaling Group
################################################################################
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "geocitizen-asg-${var.environment}"

  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 4
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.public_subnets
  key_name                  = var.keypair_name
  target_group_arns         = module.alb.target_group_arns


  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name            = "geocit-asg-launch-template"
  launch_template_description     = "Launch template geocitizen"
  launch_template_use_name_prefix = true
  update_default_version          = true
  security_groups                 = [module.sg_instances.security_group_id]
  image_id                        = data.aws_ami.ubuntu_latest.id
  instance_type                   = var.instance_shape
  user_data = base64encode(templatefile("./init_web.tftpl", {
    docker_password = var.nexus_docker_password
    VERSION         = var.node_exporter_VERSION
    }
  ))

  credit_specification = {
    cpu_credits = "standard"
  }
  scaling_policies = {
    my-policy = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
          resource_label         = "Geocitizen-ASG-${var.environment}"
        }
        target_value = 50.0
      }
    }
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance-${var.environment}" }
    }
  ]

  tags = {
    Environment = var.environment
  }
}

################################################################################
# Application Load Balancer
################################################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "geocit-alb-${var.environment}"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.sg_web_lb.security_group_id]


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
        timeout             = 5
        healthy_threshold   = 3
        unhealthy_threshold = 3
        matcher             = "200-299"
      }
      #   targets = [
      #     {
      #       port = 8080
      #     }
      #   ]
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
    Environment = var.environment
  }
}

################################################################################
# Route53
################################################################################
data "aws_route53_zone" "primary" {
  name = var.domain
}
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_id = data.aws_route53_zone.primary.zone_id
  records = jsonencode([
    {
      name            = "dbgeo"
      allow_overwrite = true
      type            = "A"
      ttl             = 3600
      records = [
        module.ec2_instance.private_ip,
      ]
    },
    {
      name            = "geocitizen"
      allow_overwrite = true
      type            = "A"
      zone_id         = data.aws_route53_zone.primary.zone_id
      alias = {
        name = module.alb.lb_dns_name
        #UUUHHHHHH
        zone_id = module.alb.lb_zone_id
      }
    }
  ])
}
