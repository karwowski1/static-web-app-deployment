output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "role_arn_plan" {
  value = aws_iam_role.plan_role.arn
}

output "role_arn_apply" {
  value = aws_iam_role.apply_role.arn
}