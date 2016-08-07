resource "aws_ecs_service" "hhvm" {
  name = "hhvm"
  cluster = "${aws_ecs_cluster.hhvm.id}"
  task_definition = "${aws_ecs_task_definition.hhvm.arn}"
  desired_count = 2
  iam_role = "ecsServiceRole"

  load_balancer {
    elb_name = "hhvm"
    container_name = "hhvm"
    container_port = 9000
  }
}

resource "aws_ecs_service" "httpd" {
  name = "httpd"
  cluster = "${aws_ecs_cluster.hhvm.id}"
  task_definition = "${aws_ecs_task_definition.httpd.arn}"
  desired_count = 2
  iam_role = "ecsServiceRole"

  load_balancer {
    elb_name = "${aws_elb.httpd.name}"
    container_name = "httpd"
    container_port = 80
  }
}
