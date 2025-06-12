resource "aws_s3_bucket" "corecrm-media" {
  bucket = "corecrm-media"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
