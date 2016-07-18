variable "zones"{
  default = "a,b"
} 
variable "region" {
    default = "us-east-1"
}
variable "amis" {
    default = ""
}
variable "key_name" {
    default = ""
}
variable "instance_type" {
    default = "t2.micro"
}
variable "security_group_name" {
    default = "mongodb-sg"
}
variable "vpc_id" {
    default = "vpc-"
}
variable "subnet_id" {
    default = "subnet-,subnet-"
}
