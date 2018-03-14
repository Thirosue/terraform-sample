#####################################
# Service Setting
#####################################
resource "aws_ecs_service" "nginx" {
  name = "${var.app_name}-service"
  cluster = "${aws_ecs_cluster.nginx.id}"
  task_definition = "${aws_ecs_task_definition.nginx.arn}"
  desired_count = 1
  iam_role = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.nginx.id}"
    container_name = "nginx"
    container_port = 80
  }

  depends_on = [
    "aws_alb_listener.nginx"
  ]
}

