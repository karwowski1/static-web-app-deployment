###################
# NETWORKING
###################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
    Owner   = var.owner
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
    Owner   = var.owner
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-public-subnet"
    Project = var.project_name
    Tier    = "public"
    Owner   = var.owner
  }
}

# Send any traffic that is not local (0.0.0.0/0 = the entire world) to the Internet Gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
#Adding table to the subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


###################
# SECURITY GROUP
###################
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "SG for EC2 (SSM-friendly; no inbound required)"
  vpc_id      = aws_vpc.main.id

  # Ingress: allow HTTP from anywhere. Connects
  ingress {
    from_port = 80
    to_port =   80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress: allow outbound to the Internet (SSM agent needs this).
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-ec2-sg"
    Project = var.project_name
    Owner   = var.owner
  }
}

###################
# EC2 INSTANCE
###################
resource "aws_instance" "nginx_app" {
  ami                         = "ami-0a854fe96e0b45e4e"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
  
  tags = {
    Name    = "${var.project_name}-ec2"
    Project = var.project_name
    Owner   = var.owner
  }
}

