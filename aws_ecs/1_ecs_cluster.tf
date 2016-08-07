provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_ecs_cluster" "hhvm" {
  name = "hhvm"
}
