#####################################
# ALB Setting
#####################################

# Front LB Setting
resource "aws_alb" "front" {
  name = "${var.app_name}-front-alb"
  internal = false

  security_groups = ["${aws_security_group.public_firewall.id}"]
  subnets = ["${aws_subnet.public-subnet1.id}","${aws_subnet.public-subnet2.id}"]

  access_logs {
    bucket = "${var.app_name}-accesslog"
    prefix = "alb_log"
  }

  idle_timeout = 400

  tags {
      Name = "${var.app_name}-lb"
      Group = "${var.app_name}"
  }
}

resource "aws_alb_target_group" "front" {
  name     = "${var.app_name}-front-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  target_type = "ip"

  tags {
      Name = "${var.app_name}-target-group"
      Group = "${var.app_name}"
  }
}

resource "aws_alb_listener" "front" {
  load_balancer_arn = "${aws_alb.front.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.front.id}"
    type             = "forward"
  }
}

# API LB Setting
resource "aws_alb" "api" {
  name = "${var.app_name}-api-alb"
  internal = true

  security_groups = ["${aws_security_group.internal_firewall.id}"]
  subnets = ["${aws_subnet.public-subnet1.id}","${aws_subnet.public-subnet2.id}"]

  access_logs {
    bucket = "${var.app_name}-accesslog"
    prefix = "alb_log"
  }

  idle_timeout = 400

  tags {
      Name = "${var.app_name}-lb"
      Group = "${var.app_name}"
  }
}

resource "aws_alb_target_group" "api" {
  name     = "${var.app_name}-api-target-group"
  port     = 18081
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  target_type = "ip"

  health_check {
    interval = 120
    path = "/admin/swagger-ui.html"
    matcher = "200-399"
    timeout = 30
  }

  tags {
      Name = "${var.app_name}-target-group"
      Group = "${var.app_name}"
  }
}

resource "aws_alb_listener" "api" {
  load_balancer_arn = "${aws_alb.api.id}"
  port              = "18081"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.api.id}"
    type             = "forward"
  }
}