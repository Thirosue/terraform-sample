resource "aws_ecs_cluster" "nginx" {
  name = "${var.app_name}-cluster"
}
