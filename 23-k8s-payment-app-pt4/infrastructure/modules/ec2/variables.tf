variable "vpc_id" {
  description = "ID sieci VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID prywatnej podsieci, w której stanie maszyna"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Pula adresów IP sieci VPC (do wpuszczenia ruchu do bazy)"
  type        = string
}

variable "instance_type" {
  description = "Typ instancji EC2"
  type        = string
  default     = "t3.micro"
}