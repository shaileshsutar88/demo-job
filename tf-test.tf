provider "aws" {
  access_key = "KIAIBUKRUL3JDDMQX6A"
  secret_key = "ze/8iw8m6W9fvJFyGfpIX2mrNy1XvAmrRMyk0y/j"
  region     = "ap-southeast-1"
}

resource "aws_instance" "tf-test" {
  ami           = "ami-ffbdd790"
  instance_type = "t2.micro"
}
