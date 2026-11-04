resource "aws_lb" "Clude_lb" {
  name               = "clude-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.Public_Subnet.id, aws_subnet.Private_subnet.id]

  tags = {
    Name = "Clude_lb"
  }
}
