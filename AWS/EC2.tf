# --- Variables Definition ---

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources"
}

variable "common_ami_id" {
  type        = string
  description = "The AMI ID to be used for all EC2 instances"
}

variable "common_instance_type" {
  type        = string
  description = "EC2 instance family and size"
}

variable "common_volume_type" {
  type        = string
  description = "EBS volume type"
}

variable "common_user_data" {
  type        = string
  description = "The bash script to run on instance startup"
}

variable "instance_configs" {
  description = "A list of objects containing per-instance configurations"
  type = list(object({
    name      = string
    subnet_id = string
    disk_size = number
    key_name  = string
    sg_names  = list(string)
  }))
}

# --- Provider Configuration ---

provider "aws" {
  region = var.aws_region
}

# --- Resources ---

# 1. Dynamic Data source to fetch Security Group IDs
data "aws_security_group" "selected" {
  for_each = toset(flatten([for cfg in var.instance_configs : cfg.sg_names]))
  
  filter {
    name   = "group-name"
    values = [each.key]
  }
}

# 2. EC2 Instance Resource
resource "aws_instance" "linux_server" {
  for_each = { for cfg in var.instance_configs : cfg.name => cfg }

  ami           = var.common_ami_id
  instance_type = var.common_instance_type
  user_data     = var.common_user_data
  
  key_name      = each.value.key_name
  subnet_id     = each.value.subnet_id

  vpc_security_group_ids = [
    for sg_name in each.value.sg_names : data.aws_security_group.selected[sg_name].id
  ]

  root_block_device {
    volume_type = var.common_volume_type
    volume_size = each.value.disk_size
  }

  tags = {
    Name = each.key
  }
}
