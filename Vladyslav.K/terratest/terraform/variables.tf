
variable "aws_region" {
  default = "eu-north-1"
}
variable "nexus_docker_password" {}
variable "node_exporter_VERSION" {
  default = "1.3.0"
}

variable "instance_shape" {
  default = "t3.micro"
}

variable "keypair_name" {
  default = "ss_geocit"
}

variable "domain" {
  default = "vladkarok.ml"
}

variable "vpc_name" {
  default = "Geocitizen-VPC"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr_block" {
  default = "10.255.0.0/16"
}
