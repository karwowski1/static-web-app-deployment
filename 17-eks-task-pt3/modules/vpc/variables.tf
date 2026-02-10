variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_a_cidr" {
  description = "CIDR block for the public subnet A"
  type        = string
}
variable "public_subnet_b_cidr" {
  description = "CIDR block for the public subnet B"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
}
variable "project_name" {
  description = "Name of the project"
  type        = string
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default = "my-eks-cluster"
}