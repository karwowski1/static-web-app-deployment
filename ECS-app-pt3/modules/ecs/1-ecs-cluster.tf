resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs-cluster-v2"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
