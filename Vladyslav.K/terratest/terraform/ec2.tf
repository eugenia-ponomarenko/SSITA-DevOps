# data "aws_ami" "amazon_linux_latest" {
#   owners      = ["137112412989"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
#   }
# }

# data "aws_ami" "ubuntu_latest" {
#   owners      = ["099720109477"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
# }
# ################################################################################
# # ec2-instance Module
# ################################################################################
# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   name = "Geocitizen-DB"

#   ami                         = data.aws_ami.amazon_linux_latest.id
#   instance_type               = var.instance_shape
#   key_name                    = var.keypair_name
#   monitoring                  = true
#   associate_public_ip_address = true
#   ebs_optimized               = true

#   vpc_security_group_ids = [module.sg_db.security_group_id]
#   subnet_id              = module.vpc.public_subnets[0]
#   user_data = templatefile("./init_db.tftpl", {
#     docker_password = var.nexus_docker_password
#     VERSION         = var.node_exporter_VERSION
#     }
#   )

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
