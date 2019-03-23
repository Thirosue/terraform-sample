resource "aws_cloudwatch_log_group" "vue_sample" {
  name = "awslogs-${var.app_name}-log"
}
