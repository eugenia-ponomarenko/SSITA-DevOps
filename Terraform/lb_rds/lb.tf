# --------------------------------------------
# Create AWS Application Load Balancer for Web

resource "aws_lb" "tf_lb_webserver" {
  name                             = local.lb_name
  internal                         = false
  security_groups                  = ["${aws_security_group.GeoCitizen_LB.id}"]
  subnets                          = local.eu_central_1ab
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "citizen_tg" {
  name        = local.tg_name
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = local.vpc_id

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 1800
  }

  health_check {
    path                = "/citizen/index.html"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

# Create a Listener 
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.tf_lb_webserver.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.citizen_tg.arn
    type             = "forward"
  }
}

# Create Security Groups
resource "aws_security_group" "GeoCitizen_LB" {
  name        = local.lb_security_group
  description = "Security Group for Web Server"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
