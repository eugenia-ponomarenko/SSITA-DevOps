# ###########################
# # Security groups examples
# ###########################
# module "sg_db" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "Geocitizen-DB"
#   description = "Security group for Geocitizen DB"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
#   ingress_rules       = ["postgresql-tcp"]
#   egress_rules        = ["all-all"]
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "SSH"
#       cidr_blocks = "0.0.0.0/0"
#     },
#   ]
# }
# module "sg_web_lb" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "Geocitizen-WEB"
#   description = "Security group for Geocitizen WEB LB"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-80-tcp", "ssh-tcp"]
#   egress_rules        = ["all-all"]
# }

# module "sg_instances" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "Geocitizen-instances"
#   description = "Security group for Geocitizen web instances"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-8080-tcp", "ssh-tcp"]
#   egress_rules        = ["all-all"]
# }
