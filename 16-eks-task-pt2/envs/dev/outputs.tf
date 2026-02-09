output "configure_kubectl" {
  value = "aws eks update-kubeconfig --region eu-central-1 --name ${module.eks.cluster_name}"
}

output "role_arn_plan" {
  value = aws_iam_role.plan_role.arn
}
output "role_arn_apply" {
  value = aws_iam_role.apply_role.arn
}