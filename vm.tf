# Reference the existing resource group
resource "alicloud_resource_manager_resource_group" "existing" {
  resource_group_name = var.resource_group_name
  display_name        = "My Terraform Resource Group for ECS and OSS"
}

# Data source for availability zones
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

# Create Security Group
resource "alicloud_security_group" "pat-sg" {
  security_group_name     = "terraform-sg"
  vpc_id                  = alicloud_vpc.default.id
  description             = "Security group for Terraform VM"
}

# Create VPC and VSwitch (required for VM)
resource "alicloud_vpc" "default" {
  vpc_name   = "terraform-vpc"
  cidr_block = "10.0.0.0/26"
}

resource "alicloud_vswitch" "default" {
  vpc_id     = alicloud_vpc.default.id
  cidr_block = "10.0.0.0/28"
  zone_id    = data.alicloud_zones.default.zones[0].id
}

# SSH Inbound Rule
resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.pat-sg.id
  cidr_ip           = "0.0.0.0/0"
}

# All Outbound Rule
resource "alicloud_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.pat-sg.id
  cidr_ip           = "0.0.0.0/0"
}

## Create Elastic IP (EIP)
#resource "alicloud_eip" "vm_eip" {
#  bandwidth            = "10"  # Bandwidth in Mbps
#  resource_group_id    = var.resource_group_id
#}

resource "alicloud_instance" "pat-vm" {
  availability_zone = data.alicloud_zones.default.zones.0.id
  security_groups = [alicloud_security_group.pat-sg.id]

  instance_name = "patrina-test-instance"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = var.name
  system_disk_description    = "Terraform_test_description"
  image_id                   = var.image_id
  instance_type              = var.instance_type
  vswitch_id                 = alicloud_vswitch.default.id
  internet_max_bandwidth_out = 1
  key_name                   = "pat-key"
  resource_group_id          = var.resource_group_id
}

#resource "alicloud_eip_association" "eip_assoc" {
#  allocation_id = alicloud_eip.vm_eip.id
#  instance_id   = alicloud_instance.pat-vm.id
#  instance_type = "EcsInstance"
#}

