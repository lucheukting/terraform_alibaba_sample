#variable "access_key" {
#  description = "Alibaba Cloud Access Key"
#  type        = string
#  sensitive   = true
#}
#
#variable "secret_key" {
#  description = "Alibaba Cloud Secret Key"
#  type        = string
#  sensitive   = true
#}

variable "name" {
  default = "terraform-example"
}


variable "region" {
  description = "Alibaba Cloud region"
  type        = string
  default     = "cn-hongkong"
}

#variable "resource_group_id" {
#  description = "ID of the existing resource group"
#  type        = string
#}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "ecs.t5-lc1m2.small"
}

variable "image_id" {
  description = "Image ID for the VM"
  type        = string
  default     = "ubuntu_24_04_x64_20G_alibase_20250113.vhd"
}

variable "resource_group_name" {
  default = "terraform-test-dev"
}

variable "resource_group_id" {
  default = "rg-aek4y5px2arqi4a"
}