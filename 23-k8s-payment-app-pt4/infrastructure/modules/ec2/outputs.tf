output "vm_private_ip" {
  description = "The private IP address of the PostgreSQL VM instance."
  value       = aws_instance.postgres_vm.private_ip
}
