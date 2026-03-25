
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2-cloudwatch-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#Send metrics and logs to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#Allow EC2 to write to SSM Parameter Store
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Create an instance profile to attach the role to EC2 instances
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-cloudwatch-ssm-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}
