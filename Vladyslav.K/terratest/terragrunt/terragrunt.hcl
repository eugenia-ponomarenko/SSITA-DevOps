remote_state {
  backend = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = "terraform-tfstate-file-softserve-geocit"
    key            = "${path_relative_to_include()}/terragrunt_terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

generate "terraform_providers" {
  path      = "_providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {}
  EOF
}

# Load Variables
terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      "${get_terragrunt_dir()}/../common.tfvars"
    ]
  }
}
