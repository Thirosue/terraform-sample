resource "aws_ecs_cluster" "auth" {
  name = "${var.app_name}-auth"
}
