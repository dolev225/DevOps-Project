data "aws_availability_zones" "available" {
  state = "available"
}

# 1. יצירת ה-VPC בטווח הגדול
resource "aws_vpc" "instans_vpc" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "test1"
  }  
}

# 2
resource "aws_subnet" "subnet_instans" {
  vpc_id                  = aws_vpc.instans_vpc.id
  cidr_block              = "10.0.1.0/24" 
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "CPU-stress-Subnet-1"
  }
}

# 4. חיבור לאינטרנט (IGW)
resource "aws_internet_gateway" "gw1" {
  vpc_id = aws_vpc.instans_vpc.id
  tags = {
    Name = "test1-igw"
  }
}

# 5. טבלת ניתוב ציבורית
resource "aws_route_table" "rt_Public" {
  vpc_id = aws_vpc.instans_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw1.id
  }
  tags = {
    Name= "test1-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_instans.id
  route_table_id = aws_route_table.rt_Public.id
}