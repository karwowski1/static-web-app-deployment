data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web-1" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Env       = "prod"
    App       = "web"
    Role      = "frontend"
    AutoAlert = "true"

  }
}

resource "aws_instance" "api-1" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Env       = "prod"
    App       = "api"
    Role      = "backend"
    AutoAlert = "true"
  }
}

resource "aws_instance" "worker-1" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Env       = "prod"
    App       = "worker"
    Role      = "processing"
    AutoAlert = "true"
  }
}
