resource "aws_subnet" "public_subnet_1a"{
  vpc_id            = aws_vpc.main.id
  cidr_block        = "15.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  
    tags = {
        Name = "ecs-app-v2-public-subnet-1a"
        ecs_cluster = "true"
        ecs_service = "true"
        ecs_task = "true"
    }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "15.0.2.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true

    tags = {
        Name = "ecs-app-v2-public-subnet-1b"
        ecs_cluster = "true"
        ecs_service = "true"
        ecs_task = "true"
    }
}

