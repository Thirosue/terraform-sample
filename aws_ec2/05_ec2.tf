#####################################
# EC2
#####################################
/*
resource "aws_instance" "solr" {
    count = 6
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
}
*/

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