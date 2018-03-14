#####################################
# EC2
#####################################
resource "aws_instance" "solr" {
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "solr"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "200"
    }
    private_ip = "192.168.200.1"
}

resource "aws_instance" "solr2" {
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "solr2"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "200"
    }
    private_ip = "192.168.200.2"
}

resource "aws_instance" "solr3" {
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "solr3"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "200"
    }
    private_ip = "192.168.200.3"
}

resource "aws_instance" "solr4" {
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "solr4"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "200"
    }
    private_ip = "192.168.200.4"
}

resource "aws_instance" "solr5" {
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "solr5"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "200"
    }
    private_ip = "192.168.200.5"
}

resource "aws_instance" "solr6" {
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "solr6"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "200"
    }
    private_ip = "192.168.200.6"
}

resource "aws_instance" "batch" {
    count = 1
    ami = "${lookup(var.aws_amis, var.region)}"
    subnet_id = "${aws_subnet.public-subnet1.id}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [
        "${aws_security_group.public_firewall.id}"
    ]
    tags {
      Name = "batch"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      volume_type = "gp2"
      volume_size = "20"
    }
    user_data = "${file("user_data/userdata.sh")}"
}