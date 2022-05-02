terraform {
  required_version = ">= 0.13.1"
  backend "s3" {
    bucket         = "terraform-tfstate-file-softserve-geocit"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.11"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
