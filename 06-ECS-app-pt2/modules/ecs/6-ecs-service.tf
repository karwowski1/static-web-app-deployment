resource "aws_ecs_service" "ecs_service" {
    name          = "${var.project_name}-ecs-v2"
    launch_type   = "FARGATE"
    cluster       = aws_ecs_cluster.ecs_cluster.id
    desired_count = 1

        network_configuration  {
            assign_public_ip = false
            security_groups = [aws_security_group.ecs_task.id]
            subnets = var.private_subnet_ids
        }

    task_definition = aws_ecs_task_definition.ecs_task_def.id

        load_balancer  {
            target_group_arn = var.target_group_arn
            container_name   = "${var.project_name}-container"
            container_port   = 8080
        }
}    
