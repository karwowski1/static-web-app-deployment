resource "aws_security_group" "ecs_taks" {
    name = "${var.project_name}-ecs-tasks-sg"
    description = "Allow inbound access from the ALB only"
    vpc_id = var.vpc_id


    ingress {
        protocol        = "tcp"
        from_port       = 8080
        to_port         = 8080
        security_groups = [var.alb_security_group_id] 
    }


    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-ecs-tasks-sg"
    }
}
  