output "security_group_id_ecs" {
  description = "The security group ID for the ECS service"
  value       = aws_security_group.ecs_service.id
}