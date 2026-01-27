# --------------
# ECS tasks SG
# --------------
resource "aws_security_group" "tasks" {
  name        = "${var.name}-tasks-sg"
  description = "ECS tasks security group"
  vpc_id      = aws_vpc.main.id

  ingress {
  protocol        = "tcp"
  from_port       = var.container_port
  to_port         = var.container_port
  security_groups = [var.alb_security_group_id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_vpc.main,
    aws_security_group.alb
  ]
}
