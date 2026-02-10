output "configure_kubectl" {
  value = "aws eks update-kubeconfig --region eu-central-1 --name ${module.eks.cluster_name}"
}

output "role_arn_plan" {
  value = aws_iam_role.plan_role.arn
}
output "role_arn_apply" {
  value = aws_iam_role.apply_role.arn
}

output "bastion_id" {
  description = "ID of the Bastion Instance"
  value       = module.bastion.bastion_instance_id
}