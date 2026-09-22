data "aws_availability_zones" "available" {
  state = "available"
}

# 1. יצירת ה-VPC בטווח הגדול
resource "aws_vpc" "CPU_stress_vpc" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "CPU_stress_vpc"
  }  
}

# 2. סאבנט ראשון - בטווח קטן יותר (10.0.1.0/24)
resource "aws_subnet" "CPU_stress_Subnet" {
  vpc_id                  = aws_vpc.CPU_stress_vpc.id
  cidr_block              = "10.0.1.0/24" # תיקון: מונע התנגשות עם ה-VPC
  map_public_ip_on_launch = var.if_Public_ip
  availability_zone       = "us-east-1a"
  tags = {
    Name = "CPU-stress-Subnet-1"
  }
}

# 3. סאבנט שני - בטווח נפרד (10.0.2.0/24) וב-AZ שונה
resource "aws_subnet" "CPU_stress_Subnet_2" {
  vpc_id                  = aws_vpc.CPU_stress_vpc.id
  cidr_block              = "10.0.2.0/24" # תיקון: מונע התנגשות עם סאבנט 1
  availability_zone       = "us-east-1b" 
  map_public_ip_on_launch = true
  tags = { Name = "CPU-stress-Subnet-2" }
}

# 4. חיבור לאינטרנט (IGW)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.CPU_stress_vpc.id
  tags = {
    Name = "CPU-stress-igw"
  }
}

# 5. טבלת ניתוב ציבורית
resource "aws_route_table" "rt_Public" {
  vpc_id = aws_vpc.CPU_stress_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name= "CPU-stress-rt"
  }
}

# 6. שיוך שני הסאבנטים לטבלת הניתוב כדי שיהיו ציבוריים
resource "aws_route_table_association" "con_Public_rt_1" {
  subnet_id      = aws_subnet.CPU_stress_Subnet.id 
  route_table_id = aws_route_table.rt_Public.id
}

resource "aws_route_table_association" "con_Public_rt_2" {
  subnet_id      = aws_subnet.CPU_stress_Subnet_2.id 
  route_table_id = aws_route_table.rt_Public.id
}

# 7. Security Group
resource "aws_security_group" "CPU_stress_sg" {
  name   = "CPU_stress_sg"
  vpc_id = aws_vpc.CPU_stress_vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}