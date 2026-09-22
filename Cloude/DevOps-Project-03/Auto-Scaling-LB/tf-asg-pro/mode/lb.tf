resource "aws_lb" "CPU_stress_lb" {
  name               = "CPU-stress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.CPU_stress_sg.id]
  subnets            = [aws_subnet.CPU_stress_Subnet.id,aws_subnet.CPU_stress_Subnet_2.id]

  tags = {
    Name = "CPU-stress-alb"
  }
}