output "role_plan_arn" {
  description = "ARN for the planning role"
  value       = aws_iam_role.plan_role.arn
}

output "role_apply_arn" {
  description = "ARN for the apply role"
  value       = aws_iam_role.apply_role.arn
}