provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.region}"
}

#Provisioning the machine
resource "aws_instance" "web" {
    count = "1"
    ami = "${var.amis}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    availability_zone = "${var.region}${element(split(",",var.zones),count.index)}"
    vpc_security_group_ids = ["${aws_security_group.demo_sg.id}"]
   #placement_group = "${aws_placement_group.web.id}"
    subnet_id = "${element(split(",",var.subnet_id),count.index)}"
    user_data = "${file("mongo-config.sh")}"
	tags {
    Name = "mongo-server${count.index + 1}"
    Owner = "pradeep"
  }
}
 resource "aws_placement_group" "web" {
    name = "dev-general"
    strategy = "cluster"
}

 resource "aws_security_group" "demo_sg" {
  vpc_id = "${var.vpc_id}"
  name = "${var.security_group_name}"
  description = "demo security group"
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["10.128.0.0/10"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "example" {
  count = "1"
  availability_zone = "${var.region}${element(split(",",var.zones),count.index)}"
  type = "gp2"
  size = "1"
  tags {
        Name = "MongoMonDBA${count.index}"
    }
}

resource "aws_volume_attachment" "ebs_att" {
  count = "1"
  device_name = "/dev/xvdh"
  volume_id = "${element(aws_ebs_volume.example.*.id, count.index)}"
  instance_id = "${element(aws_instance.web.*.id, count.index)}"
}

resource "aws_ebs_volume" "example1" {
  count = "1"
  availability_zone = "${var.region}${element(split(",",var.zones),count.index)}"
  type = "gp2"
  size = "1"
  tags {
        Name = "MongoMonBACKUP${count.index}"
    }
}

resource "aws_volume_attachment" "ebs_att1" {
  count = "1"
  device_name = "/dev/xvdg"
  volume_id = "${element(aws_ebs_volume.example1.*.id, count.index)}"
  instance_id = "${element(aws_instance.web.*.id, count.index)}"
}
