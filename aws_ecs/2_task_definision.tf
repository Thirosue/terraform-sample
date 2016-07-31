resource "aws_ecs_task_definition" "hhvm" {
  family = "hhvm"
  container_definitions = "${file("task-definitions/hhvm.json")}"
}
