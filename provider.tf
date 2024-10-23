provider "aws" {
  region     = "ap-southeast-2" # 修改为你想要的区域
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
