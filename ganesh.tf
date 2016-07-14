provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "jenkins-poc" {
  count = "2"
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  availability_zone = "${var.aws_region}${element(split(",",var.zones),count.index)}"
  vpc_security_group_ids = ["${aws_security_group.jenkins-poc.id}"]
  subnet_id = "${element(split(",",var.subnet_id),count.index)}"
  user_data = "${file("userdata.sh")}"
  tags {
    Name = "jenkins-poc${count.index + 1}"
    Owner = "shailesh"
  }
}

resource "aws_elb" "jenkins-poc-elb" {
  name = "jenkins-poc-elb"
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
    listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:80/"
    interval = 60
  }

instances = ["${aws_instance.jenkins-poc.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 400

}

resource "aws_security_group" "jenkins-poc" {
  vpc_id = "${var.vpc_id}"
  name = "jenkins-poc"
  description = "Allow http,httpd and SSH"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "http"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "https"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "ssh"
      cidr_blocks = ["0.0.0.0/0"]
  }

}
