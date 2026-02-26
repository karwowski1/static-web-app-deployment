output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1b.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id
  ]
}

output "vpc_cidr_block" {
  description = "Adresacja CIDR sieci VPC"
  value       = aws_vpc.main.cidr_block
}