resource "aws_ecs_cluster" "vue" {
  name = "${var.app_name}-cluster"
}
