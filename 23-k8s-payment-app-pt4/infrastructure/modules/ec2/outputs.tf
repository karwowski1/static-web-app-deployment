output "vm_private_ip" {
  description = "Prywatny adres IP naszej nowej bazy danych"
  value       = aws_instance.postgres_vm.private_ip
}