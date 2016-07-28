provider "aws" {
  region     = "${var.region}"
}

resource "aws_instance" "terraform-test" {
  count = "1"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  tags {
        Name = "terraform-test${count.index + 1}"
        Owner= "Shailesh"
  }
}

