variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}