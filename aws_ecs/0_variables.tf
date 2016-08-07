#######################
# Required
#######################

variable "access_key" {}
variable "secret_key" {}

# SSH key
variable "ssh_key_name" {}

# security group internal
variable "security_groups_internal" {}

# security group dmz
variable "security_groups_dmz" {}

# internal elb for hhvm
variable "hhvm_vip" {}

#######################
# Option
#######################

variable "region" {
  default = "ap-northeast-1"
}

variable "aws_amis" {
  default = {
      "ap-northeast-1" = "ami-2b08f44a"
  }
}

# Instance Type
variable "instance_type" {
  default = "t2.micro"
}
