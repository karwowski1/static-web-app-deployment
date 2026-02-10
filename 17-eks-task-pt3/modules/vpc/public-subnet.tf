resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "${var.project_name}-public-1a"
    "kubernetes.io/role/elb" = "1"  
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "${var.project_name}-public-1b"
    "kubernetes.io/role/elb" = "1"
  }
}