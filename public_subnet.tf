# 创建共有子网
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a" # 选择可用区
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# # 创建互联网网关
  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "my_internet_gateway"
    }
  }

  # 创建路由表
  resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "public_route_table"
    }
  }

  # 关联路由表到公有子网
  resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
  }