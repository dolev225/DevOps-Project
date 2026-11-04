data "aws_availability_zones" "available" {
  state = "available"
}

# 1. VPC מרכזי יחיד המרכז את כל הרשת
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main-vpc"
  }
}

# 2. סאב-נט ציבורי (ל-ALB / אינטרנט)
resource "aws_subnet" "Public_Subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = var.if_Public_ip
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "Public_Subnet"
  }
}

# 3. סאב-נט פרטי (לשרתי ה-Flask / אבטחה)
resource "aws_subnet" "Private_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private_subnet"
  }
}

# 4. Internet Gateway לחיבור ה-VPC לאינטרנט
resource "aws_internet_gateway" "Public_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Public_igw"
  }
}

# 5. טבלת ניתוב (Route Table) לציבור
resource "aws_route_table" "Public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Public_gw.id
  }
  tags = {
    Name = "Public_route_table"
  }
}

# 6. חיבור ה-Subnet הציבורי לטבלת הניתוב
resource "aws_route_table_association" "connet_Public_rt_1" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_rt.id
}

# 7. Elastic IP ו-NAT Gateway עבור הרשת הפרטית
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.Public_Subnet.id
  tags = {
    Name = "Main-NAT-Gateway"
  }
}

# 8. טבלת ניתוב פרטית וחיבור לסאב-נט הפרטי
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Private_route_table"
  }
}

resource "aws_route_table_association" "connect_private_rt" {
  subnet_id      = aws_subnet.Private_subnet.id
  route_table_id = aws_route_table.private.id
}

# 9. ניתוב ברירת מחדל מהרשת הפרטית החוצה דרך ה-NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw.id
}