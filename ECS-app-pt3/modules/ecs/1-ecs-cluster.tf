resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}-v2"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
