#####################################
# Service Setting
#####################################
resource "aws_ecs_service" "nginx" {
  name = "${var.app_name}-auth-service"
  cluster = "${aws_ecs_cluster.auth.id}"
  task_definition = "${aws_ecs_task_definition.nginx.arn}"
  desired_count = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.nginx.id}"
    container_name = "nginx"
    container_port = 80
  }

  network_configuration {
    subnets = [
      "${aws_subnet.public-subnet1.id}",
      "${aws_subnet.public-subnet2.id}"
    ]

    security_groups = [
      "${aws_security_group.public_firewall.id}"
    ]

    assign_public_ip = "ENABLED"
  }

  depends_on = [
    "aws_alb_listener.nginx"
  ]
}