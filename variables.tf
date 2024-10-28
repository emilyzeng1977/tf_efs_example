variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "tom-pair" # 修改为你想要的密钥对名称
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "EC2 instance ami"
  type        = string
  default     = "ami-0043df2e553ad12b6"
}

variable "instance_count" {
  description = "number of EC2 instance "
  type        = number
  default     = 2
}

# 定义已有的 EFS ID
# variable "efs_id" {
#   type    = string
#   default = "fs-0d1f617b3eb94a552"  # 替换为已有的 EFS 文件系统 ID
# }