resource "aws_ecs_service" "hhvm" {
  name = "hhvm"
  cluster = "${aws_ecs_cluster.hhvm.id}"
  task_definition = "${aws_ecs_task_definition.hhvm.arn}"
  desired_count = 3
  iam_role = "ecsServiceRole"

  load_balancer {
    elb_name = "${aws_elb.hhvm.name}"
    container_name = "hhvm"
    container_port = 9000
  }
}
