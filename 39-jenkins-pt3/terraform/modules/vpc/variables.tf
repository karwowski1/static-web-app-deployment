variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "aws_region" {
  type = string

}
variable "endpoint_sg_id" {
  description = "ID of the security group for VPC endpoints"
  type        = string
}
