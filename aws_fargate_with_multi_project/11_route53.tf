#####################################
# DNS Setting
#####################################

resource "aws_route53_zone" "vue" {
  name = "${var.local_dns}"

  vpc {
    vpc_id   = "${aws_vpc.vpc.id}"
  }
}

# API Settings
resource "aws_route53_record" "api" {
  zone_id = "${aws_route53_zone.vue.zone_id}"
  name = "api.${var.local_dns}"
  type = "A"

  alias {
    name = "${aws_alb.api.dns_name}"
    zone_id = "${aws_alb.api.zone_id}"
    evaluate_target_health = false
  }

  depends_on = [
    "aws_alb.api"
  ]
}