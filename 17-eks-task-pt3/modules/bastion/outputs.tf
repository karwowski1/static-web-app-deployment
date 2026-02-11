output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_role_arn" {
  value = aws_iam_role.bastion_role.arn
}

output "bastion_security_group_id" {
  description = "ID of the Bastion Security Group"
  value       = aws_security_group.bastion_sg.id
}