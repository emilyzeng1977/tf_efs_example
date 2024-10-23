
# 创建 EFS 文件系统
resource "aws_efs_file_system" "my_efs" {
  performance_mode = "generalPurpose"

  tags = {
    Name = "my_efs"
  }
}

# 在子网中创建 EFS 挂载目标
resource "aws_efs_mount_target" "example" {
  file_system_id = aws_efs_file_system.my_efs.id
  subnet_id      = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.efs_sg.id]  # 关联安全组

  lifecycle {
    create_before_destroy = true  # 确保在替换时先创建新目标
  }
}