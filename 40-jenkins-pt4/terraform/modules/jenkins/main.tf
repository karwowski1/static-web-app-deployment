data "aws_subnet" "selected" {
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
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "jenkins_controller" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_controller_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
                #!/bin/bash
                while [ ! -b /dev/sdh ]; do sleep 5; done
                sudo mkfs -t xfs /dev/sdh || true
                sudo mkdir -p /var/lib/jenkins
                sudo mount /dev/sdh /var/lib/jenkins
                echo '/dev/sdh /var/lib/jenkins xfs defaults,nofail 0 2' | sudo tee -a /etc/fstab
                sudo yum update -y
                sudo curl -sL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                sudo dnf install java-21-amazon-corretto -y
                sudo yum install jenkins -y
                sudo chown -R jenkins:jenkins /var/lib/jenkins
                sudo systemctl enable --now jenkins
                EOF

  tags = { Name = "${var.environment}-jenkins-controller" }
}

resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = 30
  type              = "gp3"
  tags              = { Name = "${var.environment}-jenkins-data" }
}

resource "aws_volume_attachment" "jenkins_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.jenkins_data.id
  instance_id = aws_instance.jenkins_controller.id
}

resource "aws_instance" "agent_ci" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_agent_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install java-21-amazon-corretto -y
                sudo yum install docker -y
                sudo systemctl enable --now docker
                sudo usermod -aG docker ec2-user
                EOF

  tags = { Name = "${var.environment}-jenkins-agent-ci" }
}

resource "aws_instance" "agent_infra" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_agent_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install java-21-amazon-corretto -y
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                sudo yum -y install terraform
                EOF

  tags = { Name = "${var.environment}-jenkins-agent-infra" }
}
