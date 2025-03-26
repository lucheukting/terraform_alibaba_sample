resource "alicloud_oss_bucket" "pat-oss" {
  bucket = "patrina-poc-dev-oss-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  resource_group_id = var.resource_group_id
  storage_class = "Standard"  # Default storage class
  redundancy_type = "LRS"  # Local Redundancy Storage
  
  # Optional: Add lifecycle rules or other configurations
  lifecycle_rule {
    id      = "rule1"
    enabled = true
    prefix  = "logs/"
    expiration {
      days = 90  # Expire objects after 90 days
    }
  }
}

resource "alicloud_oss_bucket_acl" "default" {
  bucket = alicloud_oss_bucket.pat-oss.bucket
  acl    = "private"

}