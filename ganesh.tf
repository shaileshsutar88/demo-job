provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "tf-test" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  availability_zone = "${var.aws_region}${element(split(",",var.zones),count.index)}"
  tags {
    Name = "tf-test${count.index + 1}"
    Owner = "shailesh"
  }
}

resource "aws_elb" "tf-test-elb" {
  name = "tf-test-elb"
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

instances = ["${aws_instance.tf-test.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 400

}
