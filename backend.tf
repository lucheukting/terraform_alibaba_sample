provider "alicloud" {
  region     = "cn-hongkong"
}

terraform {
  backend "oss" {
    bucket = "terraform-test-dev"
    key    = "terraform/state"
    region = "cn-hongkong"
    endpoint = "oss-cn-hongkong.aliyuncs.com"
  }
}