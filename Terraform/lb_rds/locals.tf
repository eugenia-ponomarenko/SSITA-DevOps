locals {
  eu_central_1ab            = ["subnet-0bd44ce4febe6eacb", "subnet-0f13e4432ca16d78a"]
  lb_name                   = "TF-GeoCitizen-LB"
  webserver_security_group  = "Ubuntu Security Group"
  vpc_id                    = "vpc-008b05236db3e2d5e"
  lb_security_group         = "GeoCitizen_LB"
  postgres_security_group   = "Postgres SecurityGroup"
  db_name                   = "PostgreSQL GeoCitizen"
  tg_name                  = "tf-geocitizen"
}

variable "psql_username" { 
    sensitive = true 
    type = string
}
variable "psql_password" { 
    sensitive = true
    type = string
}
