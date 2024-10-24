# 生成TLS密钥
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# 创建AWS密钥对
resource "aws_key_pair" "example" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

# 将私钥保存到本地文件
resource "local_file" "private_key" {
  filename = "${path.module}/ec2_private_key.pem"  # 指定文件名和路径
  content  = tls_private_key.example.private_key_pem
}

# 修改私钥文件的权限为 400
resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key.filename}"  # 设置文件权限
  }

  depends_on = [local_file.private_key]  # 确保在私钥文件创建后执行
}

# 创建一个 EC2 实例
resource "aws_instance" "example" {
  ami                  = var.instance_ami  # 指定您的AMI
  instance_type        = var.instance_type
  key_name             = aws_key_pair.example.key_name
  subnet_id            = aws_subnet.public_subnet.id
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id, aws_security_group.efs_sg.id]  # 使用安全组ID
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # 运行脚本以安装 NFS 客户端并挂载 EFS
#   user_data = <<-EOF
#               #!/bin/bash
#               yum install -y nfs-utils
#               mkdir /mnt/efs
#               mount -t nfs -o nfsvers=4.1 ${aws_efs_file_system.my_efs.dns_name}:/ /mnt/efs
#               echo "${aws_efs_file_system.my_efs.dns_name}:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab
#               EOF

  # 允许自动分配公共 IP
  associate_public_ip_address = true

  tags = {
    Name = "Terraform"
  }
}