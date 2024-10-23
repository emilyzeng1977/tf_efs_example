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