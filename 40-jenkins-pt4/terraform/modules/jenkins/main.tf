data "aws_subnet" "jenkins_subnet" {
  id = var.subnet_id
}

resource "aws_security_group" "jenkins_sg" {
  name   = "${var.environment}-jenkins-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-jenkins-sg"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
                #!/bin/bash
                sudo mkfs -t xfs /dev/sdh || true
                sudo mkdir -p /var/lib/jenkins
                sudo mount /dev/sdh /var/lib/jenkins

                sudo yum update -y
                sudo curl -sL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                sudo yum upgrade -y
                sudo dnf install java-21-amazon-corretto -y
                sudo yum install jenkins -y --nogpgcheck

                sudo chown -R jenkins:jenkins /var/lib/jenkins
                sudo systemctl enable --now jenkins
              EOF

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = false
  }

  tags = {
    Name = "${var.environment}-jenkins-controller"
  }
}

resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = data.aws_subnet.jenkins_subnet.availability_zone
  size              = 30
  type              = "gp3"
  tags              = { Name = "${var.environment}-jenkins-data" }
}

resource "aws_volume_attachment" "jenkins_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.jenkins_data.id
  instance_id = aws_instance.jenkins.id
}
