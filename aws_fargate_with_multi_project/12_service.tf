#####################################
# Service Setting
#####################################

# common
resource "aws_service_discovery_private_dns_namespace" "vue_sample" {
  name        = "sample.local"
  vpc         = "${aws_vpc.vpc.id}"
}

# Front Service
resource "aws_ecs_service" "front" {
  name = "${var.app_name}-front-service"
  cluster = "${aws_ecs_cluster.vue.id}"
  task_definition = "${aws_ecs_task_definition.front.arn}"
  desired_count = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.front.id}"
    container_name = "front"
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
    assign_public_ip = "true"
  }

  depends_on = [
    "aws_alb_listener.front"
  ]
}

# API Service
resource "aws_ecs_service" "api" {
  name = "${var.app_name}-api-service"
  cluster = "${aws_ecs_cluster.vue.id}"
  task_definition = "${aws_ecs_task_definition.api.arn}"
  desired_count = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.api.id}"
    container_name = "api"
    container_port = 18081
  }

  network_configuration {
    subnets = [
      "${aws_subnet.public-subnet1.id}",
      "${aws_subnet.public-subnet2.id}"
    ]

    security_groups = [
      "${aws_security_group.internal_firewall.id}"
    ]
    assign_public_ip = "true"
  }

  depends_on = [
    "aws_alb_listener.api"
  ]
}

# DB Service
resource "aws_service_discovery_service" "db" {
  name = "db"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.vue_sample.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "db" {
  name = "${var.app_name}-db-service"
  cluster = "${aws_ecs_cluster.vue.id}"
  task_definition = "${aws_ecs_task_definition.db.arn}"
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [
      "${aws_subnet.public-subnet1.id}",
      "${aws_subnet.public-subnet2.id}"
    ]

    security_groups = [
      "${aws_security_group.internal_firewall.id}"
    ]
    assign_public_ip = "true"
  }

  service_registries {
    registry_arn = "${aws_service_discovery_service.db.arn}"
  }
}