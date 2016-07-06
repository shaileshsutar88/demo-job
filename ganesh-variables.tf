variable "aws_ami" {
  default = "ami-a59b49c6"
}

variable "zones"{
  default = "a,b"
}

variable "region" {
    default = "ap-southeast-1"
}

variable "key_name" {
    default = "test-key"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "count" {
    default = "2"
}

variable "access_key" {
	default =""
}

variable "secret_key" {
	default =""
}
