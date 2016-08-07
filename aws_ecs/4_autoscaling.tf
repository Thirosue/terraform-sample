resource "aws_launch_configuration" "hhvm" {
    name = "hhvm"
    image_id = "${lookup(var.aws_amis, var.region)}"
    key_name = "${var.ssh_key_name}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "ecsInstanceRole"
    security_groups = [
        "${var.security_groups_internal}"
    ]
    user_data = "${file("user_data/userdata.sh")}"
}

resource "aws_autoscaling_group" "hhvm" {
  availability_zones = ["ap-northeast-1a"]
  name = "hhvm"
  max_size = 2
  min_size = 2
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.hhvm.name}"
}
