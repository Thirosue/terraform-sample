resource "aws_cloudwatch_log_group" "nginx" {
  name = "awslogs-${var.app_name}-nginx-log"
}
