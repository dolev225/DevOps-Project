# target group
resource "aws_lb_target_group" "web-tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.instans_vpc.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = length(local.servers)
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web-ec2[count.index].id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}


# ALB
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = concat(aws_subnet.subnet_instans[*].id,aws_subnet.subnet_2[*].id)
}

