resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "${var.project_name}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  tags = var.tags
  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-container"
      image = "${var.container_image}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = "eu-central-1"
          "awslogs-stream-prefix" = var.project_name
        }
      }
    }
  ])
}

  