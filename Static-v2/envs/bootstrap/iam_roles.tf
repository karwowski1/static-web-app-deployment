#ROLE1q: PLAN (Read-Only Access + State Access)

resource "aws_iam_role" "plan_role" {
  name               = "GitHubActions-PlanRole"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

resource "aws_iam_role_policy_attachment" "plan_readonly" {
  role       = aws_iam_role.plan_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "state_access" {
  name = "TerraformStateAccess"
  role = aws_iam_role.plan_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}",
          "arn:aws:s3:::${var.state_bucket_name}/*"
        ]
      },
    ]
  })
}

#ROLE2: APPLY (Full Access)

resource "aws_iam_role" "apply_role" {
  name               = "GitHubActions-ApplyRole"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

locals {
  apply_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudFrontFullAccess",
    "arn:aws:iam::aws:policy/AWSWAFConsoleFullAccess", # lub AWSWAFv2FullAccess
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  ]
}

resource "aws_iam_role_policy_attachment" "apply_attach" {
  for_each   = toset(local.apply_policies)
  role       = aws_iam_role.apply_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "apply_state_access" {
  name   = "TerraformStateAccess"
  role   = aws_iam_role.apply_role.id
  policy = aws_iam_role_policy.state_access.policy
}