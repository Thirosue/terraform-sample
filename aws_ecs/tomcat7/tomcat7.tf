variable "access_key" {}
variable "secret_key" {}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "ap-northeast-1"
}

resource "aws_ecs_cluster" "tomcat7" {
  name = "tomcat7"
}

resource "aws_elb" "tomcat7" {
  name = "tomcat7"
  availability_zones = ["ap-northeast-1a"]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8080/"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}

resource "aws_ecs_service" "tomcat7" {
  name = "tomcat7"
  cluster = "${aws_ecs_cluster.tomcat7.id}"
  task_definition = "${aws_ecs_task_definition.tomcat7.arn}"
  desired_count = 3
  iam_role = "ecsServiceRole"

  load_balancer {
    elb_name = "${aws_elb.tomcat7.name}"
    container_name = "tomcat7"
    container_port = 8080
  }
}

resource "aws_ecs_task_definition" "tomcat7" {
  family = "tomcat7"
  container_definitions = "${file("task-definitions/tomcat7.json")}"
}
