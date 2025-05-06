variable "vpc_cidr" {}
variable "public_subnet_cidrs" {}
variable "azs" {}
variable "private_subnet_cidrs" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "region" {}
variable "vpc_name" {}
variable "dynamo_db" {}
variable "s3_bucket" {}
variable "test_role_arn" {
    type = string
    default = "arn:aws:iam::811362454422:role/testrole"
}
variable "qa_role_arn" {
    type = string
    default = "arn:aws:iam::811362454422:role/qarole"
}


