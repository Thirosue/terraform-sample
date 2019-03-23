#####################################
# Security Group Settings
#####################################

# For Public
resource "aws_security_group" "public_firewall" {
    name = "${var.app_name} public-firewall"
    vpc_id = "${aws_vpc.vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.root_segment}"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.app_name} public-firewall"
        Group = "${var.app_name}"
    }
    description = "${var.app_name} public-firewall"
}

# For Internal
resource "aws_security_group" "internal_firewall" {
    name = "${var.app_name} internal-firewall"
    vpc_id = "${aws_vpc.vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.root_segment}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.app_name} internal-firewall"
        Group = "${var.app_name}"
    }
    description = "${var.app_name} internal-firewall"
}