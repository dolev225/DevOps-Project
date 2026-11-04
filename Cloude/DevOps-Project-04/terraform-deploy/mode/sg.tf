# 1. Security Group עבור ה-Application Load Balancer (ציבורי)
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP and HTTPS inbound traffic to ALB"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-Security-Group"
  }
}

# 2. Security Group עבור שרתי ה-EC2 (פרטי / מאחורי ה-ALB)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow traffic only from ALB to port 5000"
  vpc_id      = aws_vpc.main_vpc.id

  # גישה לפורט האפליקציה אך ורק מה-Load Balancer
  ingress {
    description     = "Allow traffic from ALB on port 5000"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

 
  ingress {
    description = "Allow SSH from anywhere (or restrict to your IP)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # מומלץ בהמשך להגביל לכתובת ה-IP שלך בלבד
  }

  egress {
    description = "Allow all outbound traffic for updates and S3 access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Security-Group"
  }
}