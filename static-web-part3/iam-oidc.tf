#Connection with GitHub - OIDC Configuration

#Fetching TLS cert
data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com"
}

#Creating OIDC provider in AWS
resource "aws_iam_openid_connect_provider" "github" {
    url = "token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.github.sha1_fingerprint]
}

#Defining repo 
locals {
    github_repo = "karwowski1/static-web-app-deployment"
}

#IAM role for TF
resource "aws_iam_role" "terraform_plan" {
    name = "GitHubActions-Terraform-Plan"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRoleWithWebIdentity"
                Effect = "Allow"
                Principal = {
                    Federated = aws_iam_openid_connect_provider.github.arn
                }
                Condition = {
                    StringLike = {
                        "token.actions.githubusercontent.com:sub" = "repo:${local.github_repo}:*"
                    }
                }
            }
        ]
    })
}

#Attach ReadOnly policy to the role
resource "aws_iam_role_policy_attachment" "plan_readonly" {
    role       = aws_iam_role.terraform_plan.name
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "plan_state_access" {
    name = "state-backend-access"
    role = aws_iam_role.terraform_plan.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObject",
                    "s3:ListBucket",
                    "dynamodb:GetItem",
                    "dynamodb:PutItem",
                    "dynamodb:DeleteItem",
                ]
                Resource = [
                    "arn:aws:s3:::tfstate-part2-lock",
                    "arn:aws:s3:::tfstate-part2-lock/*",
                    "arn:aws:dynamodb:eu-west-2:*:table/ts-locks"
                ]
            }
        ]
    })
}


resource "aws_iam_role" "terraform_apply" {
    name = "GitHubActions-Terraform-Apply"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRoleWithWebIdentity"
                Effect = "Allow"
                Principal = {
                    Federated = aws_iam_openid_connect_provider.github.arn
                }
                Condition = {
                    StringLike = {
                        "token.actions.githubusercontent.com:sub" = "repo:${local.github_repo}:*"
                    }
                }
            }
        ]
    })
}

#Admin access for apply role
resource "aws_iam_role_policy_attachment" "apply_admin" {
    role       = aws_iam_role.terraform_apply.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "role_plan_arn" {
    description = "ARN of the IAM role for TF Plan"
    value       = aws_iam_role.terraform_plan.arn
}

output "role_apply_arn" {
  description = "ARN of the IAM role for TF apply"
  value = "aws_iam_role.terraform_apply.arn"
}