data "aws_subnet" "public" {
  id = var.public_subnet_id
}

data "aws_subnet" "private" {
  id = var.private_subnet_id
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

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
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
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_controller_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Resolve root disk robustly
    ROOT_PART=$(findmnt -nvo SOURCE /)
    ROOT_DISK=$(lsblk -no PKNAME $ROOT_PART | head -n 1)
    if [ -z "$ROOT_DISK" ]; then
      ROOT_DISK="nvme0n1" # fallback for AWS Nitro
    fi
    
    DEVICE=""
    while [ -z "$DEVICE" ]; do
      sleep 5
      DEVICE=$(lsblk -dpno NAME,TYPE | grep "disk" | grep -v "$ROOT_DISK" | awk '{print $1}' | head -n 1)
    done
    
    if ! blkid $DEVICE; then
      sudo mkfs -t xfs $DEVICE
    fi
    sudo mkdir -p /var/lib/jenkins
    sudo mount $DEVICE /var/lib/jenkins
    
    UUID=$(blkid -s UUID -o value $DEVICE)
    if [ -n "$UUID" ]; then
      echo "UUID=$UUID /var/lib/jenkins xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
    fi

    sudo yum update -y
    sudo yum install git -y
    sudo curl -sL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo dnf install java-21-amazon-corretto -y
    sudo yum install jenkins -y
    sudo chown -R jenkins:jenkins /var/lib/jenkins
    sudo systemctl enable --now jenkins
  EOF

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = { Name = "${var.environment}-jenkins-controller" }
}

resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = data.aws_subnet.public.availability_zone
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
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_agent_profile.name
  key_name               = var.key_name
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install git -y
    sudo yum install java-21-amazon-corretto -y
    sudo yum install docker -y
    sudo systemctl enable --now docker
    sudo usermod -aG docker ec2-user
  EOF
  tags                   = { Name = "${var.environment}-jenkins-agent-ci" }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
}

resource "aws_instance" "agent_infra" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_agent_profile.name
  key_name               = var.key_name
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install git -y
    sudo yum install java-21-amazon-corretto -y
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
  EOF
  tags                   = { Name = "${var.environment}-jenkins-agent-infra" }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
}
