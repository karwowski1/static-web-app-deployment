resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-cluster"
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.environment}-task-api"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "task-api"
    image = "${aws_ecr_repository.app.repository_url}:latest"
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.app_logs.name
        "awslogs-region"        = "eu-central-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}
