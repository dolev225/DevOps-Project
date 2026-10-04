resource "aws_security_group" "web-sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP only from the load balancer"
  vpc_id      = aws_vpc.instans_vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}