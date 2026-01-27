data "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_policy" "tf_backend_access" {
  name        = "TerraformBackendAccess-troubleshoot-task"
  description = "Access to S3 state locks"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",     #Allows to create lock file
          "s3:DeleteObject"   #Allows to delete lock file
        ],
        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
      }
    ]
  })
}

# ROLA 1: PLAN (ReadOnly + State Access)
resource "aws_iam_role" "plan_role" {
  name = "GitHubActions-Plan-troubleshoot-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = { Federated = data.aws_iam_openid_connect_provider.github.arn }
      Condition = {
        StringLike = { "token.actions.githubusercontent.com:sub" : "repo:${var.github_repo}:*" }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "plan_readonly" {
  role       = aws_iam_role.plan_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "plan_backend" {
  role       = aws_iam_role.plan_role.name
  policy_arn = aws_iam_policy.tf_backend_access.arn
}

# ROLA 2: APPLY
resource "aws_iam_role" "apply_role" {
  name = "GitHubActions-Apply-troubleshoot-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = { Federated = data.aws_iam_openid_connect_provider.github.arn }
      Condition = {
        StringLike = { "token.actions.githubusercontent.com:sub" : "repo:${var.github_repo}:*" }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apply_admin" {
  role       = aws_iam_role.apply_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "apply_backend" {
  role       = aws_iam_role.apply_role.name
  policy_arn = aws_iam_policy.tf_backend_access.arn
}