resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "main_subnet"
  }
}

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

#   # 允许从 EC2 实例到 EFS 的 NFS 2049 端口
#   ingress {
#     from_port   = 2049
#     to_port     = 2049
#     protocol    = "tcp"
#     security_groups = [aws_security_group.efs_sg.id]  # 引用EFS的安全组
#   }

  # 出站规则：允许所有流量
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 创建一个 EC2 实例
resource "aws_instance" "example" {
  ami                  = var.instance_ami  # 指定您的AMI
  instance_type        = var.instance_type
  key_name             = aws_key_pair.example.key_name
  subnet_id            = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # 使用安全组ID

  tags = {
    Name = "Terraform"
  }
}
