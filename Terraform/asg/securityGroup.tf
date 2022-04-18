resource "aws_security_group" "ubuntuSecurityGroup" {
  name        = local.webserver_security_group
  description = "GeoCitizen. SecurityGroup for Ubuntu"
  dynamic "ingress" {
    for_each = var.ec2_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
