resource "aws_lb_target_group" "alb_example" {
  name        = "${var.project_name}-tg"
  target_type = "ip"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
    health_check {
        enabled             = true
        interval            = 300
        path                = "/"
        port                = "8080"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
        healthy_threshold   = 2
    }
  tags = var.tags  
}
