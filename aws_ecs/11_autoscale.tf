#####################################
# Instance Auto Scale Setting
#####################################
resource "aws_autoscaling_group" "nginx" {
  availability_zones = ["${var.az1}"]
  name = "${var.app_name}-autoscaling-group"
  vpc_zone_identifier  = ["${aws_subnet.public-subnet1.id}","${aws_subnet.public-subnet2.id}"]
  max_size = 2
  min_size = 1
  desired_capacity = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.nginx.name}"
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.app_name}-ScaleOut-CPU-High"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.nginx.name}"
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.app_name}-ScaleIn-CPU-Low"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.nginx.name}"
}

data "template_file" "user_data" {
  template = "${file("user_data/userdata.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.nginx.name}"
  }
}

resource "aws_launch_configuration" "nginx" {
    name = "${var.app_name}-launch-configuration"
    image_id = "${lookup(var.aws_amis, var.region)}"
    key_name = "${var.aws_key_pair}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_role_profile.id}"
    security_groups = [
        "${aws_security_group.public_firewall.id}"
    ]
    user_data = "${data.template_file.user_data.rendered}"
}

resource "aws_cloudwatch_metric_alarm" "instatnce_sacle_out_alerm" {
  alarm_name          = "${var.app_name}-EC2Instance-CPU-Utilization-High-75"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.nginx.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "instatnce_sacle_in_alerm" {
  alarm_name          = "${var.app_name}-EC2Instance-Utilization-Low-25"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.nginx.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.scale_in.arn}"]
}

#####################################
# ECS Service Auto Scale Setting
#####################################
resource "aws_cloudwatch_metric_alarm" "service_sacle_out_alerm" {
  alarm_name          = "${var.app_name}-ECSService-CPU-Utilization-High-75"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    ClusterName = "${aws_ecs_cluster.nginx.name}"
    ServiceName = "${aws_ecs_service.nginx.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "service_sacle_in_alerm" {
  alarm_name          = "${var.app_name}-ECSService-CPU-Utilization-Low-25"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions {
    ClusterName = "${aws_ecs_cluster.nginx.name}"
    ServiceName = "${aws_ecs_service.nginx.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.scale_in.arn}"]
}

resource "aws_appautoscaling_target" "ecs_service_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.nginx.name}/${aws_ecs_service.nginx.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.ecs_autoscale_role.arn}"
  min_capacity       = 1
  max_capacity       = 4
}

resource "aws_appautoscaling_policy" "scale_out" {
  name                    = "scale-out"
  resource_id             = "service/${aws_ecs_cluster.nginx.name}/${aws_ecs_service.nginx.name}"
  scalable_dimension      = "${aws_appautoscaling_target.ecs_service_target.scalable_dimension}"
  service_namespace       = "${aws_appautoscaling_target.ecs_service_target.service_namespace}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  metric_aggregation_type = "Average"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }

  depends_on = ["aws_appautoscaling_target.ecs_service_target"]
}

resource "aws_appautoscaling_policy" "scale_in" {
  name                    = "scale-in"
  resource_id             = "service/${aws_ecs_cluster.nginx.name}/${aws_ecs_service.nginx.name}"
  scalable_dimension      = "${aws_appautoscaling_target.ecs_service_target.scalable_dimension}"
  service_namespace       = "${aws_appautoscaling_target.ecs_service_target.service_namespace}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  metric_aggregation_type = "Average"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }

  depends_on = ["aws_appautoscaling_target.ecs_service_target"]
}