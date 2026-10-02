data "aws_availability_zones" "available" {
  state = "available"
}

# 1
resource "aws_vpc" "instans_vpc" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "web_vpc"
  }  
}

# Subnet שני (חדש - AZ ב-us-east-1b)
resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.instans_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Web_Subnet_2"
  }
}

resource "aws_route_table_association" "rt_ass_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.rt_Public.id
}

# 2
resource "aws_subnet" "subnet_instans" {
  vpc_id                  = aws_vpc.instans_vpc.id
  cidr_block              = "10.0.1.0/24" 
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone
  tags = {
    Name = "Web_Subnet"
  }
}

# 4. IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.instans_vpc.id
  tags = {
    Name = "Web-igw"
  }
}

# 5. rt-
resource "aws_route_table" "rt_Public" {
  vpc_id = aws_vpc.instans_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name= "test1-rt"
  }
}

# 6.connet rt to IGW
resource "aws_route_table_association" "rt_ass" {
  subnet_id      = aws_subnet.subnet_instans.id
  route_table_id = aws_route_table.rt_Public.id
}