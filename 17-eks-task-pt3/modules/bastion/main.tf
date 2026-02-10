# SSM Role
resource "aws_iam_role" "bastion_role" {
  name = "${var.project_name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.project_name}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}

#Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# EC2 bastion
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  # installs kubectl on the bastion host for EKS cluster management
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              # Pobranie kubectl (wersja pasująca do EKS 1.29)
              curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mv ./kubectl /usr/local/bin/kubectl
              EOF

  tags = {
    Name = "${var.project_name}-bastion"
  }
}