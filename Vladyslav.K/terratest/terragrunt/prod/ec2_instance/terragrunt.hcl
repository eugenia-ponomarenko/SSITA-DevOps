include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../sg_db"
}

dependency "data" {
  config_path = "../data"
}

dependencies {
  paths = ["../vpc", "../sg_db", "../data"]
}

terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//?version=3.5.0"
}

locals {
  environment           = "prod"
  instance_shape        = "t3.micro"
  keypair_name          = "ss_geocit"
  node_exporter_VERSION = "1.3.1"
}

inputs = {
  name                        = "Geocitizen-DB-${local.environment}"
  ami                         = dependency.data.outputs.latest_amazon_linux_ami_id
  instance_type               = local.instance_shape
  key_name                    = local.keypair_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [dependency.sg.outputs.security_group_id]
  subnet_id                   = dependency.vpc.outputs.public_subnets[0]
  user_data = base64encode(templatefile("./init_db.tftpl", {
    docker_password = get_env("nexus_docker_password")
    VERSION         = local.node_exporter_VERSION
    }
  ))

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}

