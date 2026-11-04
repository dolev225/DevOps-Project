resource "aws_lb_target_group" "tg" {
  name     = "servers-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    matcher             = "200,302"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.Clude_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}