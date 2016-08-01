resource "aws_launch_configuration" "hhvm" {
    name = "hhvm"
    image_id = "ami-2b08f44a"
    key_name = "hirosue"
    instance_type = "t2.micro"
    iam_instance_profile = "ecsInstanceRole"
    security_groups = [
        "sg-85164de1"
    ]
    user_data = "${file("user_data/userdata.sh")}"
}

resource "aws_autoscaling_group" "hhvm" {
  availability_zones = ["ap-northeast-1a"]
  name = "hhvm"
  max_size = 1
  min_size = 1
  desired_capacity = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.hhvm.name}"
  load_balancers = ["${aws_elb.hhvm.name}"]
}
