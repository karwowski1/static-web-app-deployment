resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "ecs-app-v2-nat-eip-1a"
  }
}

resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "ecs-app-v2-nat-gw-1a"
  }
  depends_on = [ aws_internet_gateway.igw ]
}