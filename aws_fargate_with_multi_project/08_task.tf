#####################################
# Task Setting
#####################################

# Front Task Setting
data "template_file" "front_task" {
  template = "${file("task/front.json")}"

  vars {
    app_name           = "${var.app_name}"
    aws_region         = "${var.region}"
    aws_id             = "${var.aws_id}"
    api_dns            = "api.${var.local_dns}"
  }
}

resource "aws_ecs_task_definition" "front" {
  family = "front"
  container_definitions = "${data.template_file.front_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.ecs_task_role.arn}"
  cpu                      = 256
  memory                   = 512

  depends_on = [
    "aws_cloudwatch_log_group.vue_sample"
  ]
}

# API Task Setting
data "template_file" "api_task" {
  template = "${file("task/api.json")}"

  vars {
    app_name           = "${var.app_name}"
    aws_region         = "${var.region}"
    aws_id             = "${var.aws_id}"
    db_dns             = "${var.db_dns}"
  }
}

resource "aws_ecs_task_definition" "api" {
  family = "api"
  container_definitions = "${data.template_file.api_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.ecs_task_role.arn}"
  cpu                      = 256
  memory                   = 512

  depends_on = [
    "aws_cloudwatch_log_group.vue_sample"
  ]
}

# DB Task Setting
data "template_file" "db_task" {
  template = "${file("task/db.json")}"

  vars {
    app_name           = "${var.app_name}"
    aws_region         = "${var.region}"
    aws_id             = "${var.aws_id}"
  }
}

resource "aws_ecs_task_definition" "db" {
  family = "db"
  container_definitions = "${data.template_file.db_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.ecs_task_role.arn}"
  cpu                      = 256
  memory                   = 512

  depends_on = [
    "aws_cloudwatch_log_group.vue_sample"
  ]
}