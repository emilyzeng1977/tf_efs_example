resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true  # 启用 DNS 支持
  enable_dns_hostnames = true  # 启用 DNS 主机名

  tags = {
    Name = "main_vpc"
  }
}