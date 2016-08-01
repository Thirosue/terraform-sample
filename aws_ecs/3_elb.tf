resource "aws_elb" "hhvm" {
  name = "hhvm"
  availability_zones = ["ap-northeast-1a"]
  security_groups = ["sg-f2347096"]

  listener {
    instance_port = 9000
    instance_protocol = "tcp"
    lb_port = 9000
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 10
    target = "TCP:9000"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}
