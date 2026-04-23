resource "aws_iam_role" "jenkins_controller_role" {
  name = "${var.environment}-jenkins-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "jenkins_controller_profile" {
  name = "${var.environment}-jenkins-controller-profile"
  role = aws_iam_role.jenkins_controller_role.name
}

resource "aws_iam_role" "jenkins_agent_role" {
  name = "${var.environment}-jenkins-agent-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "agent_admin" {
  role       = aws_iam_role.jenkins_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "jenkins_agent_profile" {
  name = "${var.environment}-jenkins-agent-profile"
  role = aws_iam_role.jenkins_agent_role.name
}
