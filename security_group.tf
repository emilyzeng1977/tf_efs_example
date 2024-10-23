# 创建 EC2 实例的安全组
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow necessary traffic for EC2"
  vpc_id      = aws_vpc.main.id

  # 允许 SSH 访问
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 允许从任意IP连接SSH
  }

  # 出站规则：允许所有流量
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 创建EFS安全组
resource "aws_security_group" "efs_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 2049  # NFS 默认端口
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # 允许 VPC 内部访问 EFS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs_sg"
  }
}