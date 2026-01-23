resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "15.0.5.0/24"
  availability_zone = "eu-central-1a"
  
    tags = {
        Name = "ecs-app-v2-private-subnet-1a"
        ecs_cluster = "true"
        ecs_service = "true"
        ecs_task = "true"
    }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "15.0.6.0/24"
  availability_zone = "eu-central-1b"

    tags = {
        Name = "ecs-app-v2-private-subnet-1b"
        ecs_cluster = "true"
        ecs_service = "true"
        ecs_task = "true"
    }
}