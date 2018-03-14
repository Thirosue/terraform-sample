#####################################
# ALB Setting
#####################################
resource "aws_alb" "nginx" {
  name = "${var.app_name}-alb"
  internal = false

  security_groups = ["${aws_security_group.public_firewall.id}"]
  subnets = ["${aws_subnet.public-subnet1.id}","${aws_subnet.public-subnet2.id}"]

  access_logs {
    bucket = "${var.app_name}-accesslog"
    prefix = "alb_log"
  }

  idle_timeout = 400

  tags {
      Name = "${var.app_name}-alb"
      Group = "${var.app_name}"
  }
}

resource "aws_alb_target_group" "nginx" {
  name     = "${var.app_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  tags {
      Name = "${var.app_name}-target-group"
      Group = "${var.app_name}"
  }
}

resource "aws_alb_listener" "nginx" {
  load_balancer_arn = "${aws_alb.nginx.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx.id}"
    type             = "forward"
  }
}