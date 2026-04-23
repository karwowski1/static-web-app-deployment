variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "my_ip" {
  type        = string
  description = "Your public IP address for SSH and UI access"
}
variable "key_name" {
  type        = string
  description = "Name of the existing EC2 Key Pair to enable SSH access"
  default     = "jenkins-pt3-key"
}
