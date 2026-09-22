resource "aws_lb_target_group" "CPU_stress_tg" {
  name     = "CPU-stress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.CPU_stress_vpc.id

  health_check {
    protocol = "HTTP" 
    path              = "/"
    interval = 30
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.CPU_stress_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.CPU_stress_tg.arn
  }
}