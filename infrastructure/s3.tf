/******************************
# S3 bucket with encryption and public access block configurations 
******************************/

# The S3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket_prefix = "${var.name}-${var.environment}-demo-bucket"
}

# Let's make the bucket private
resource "aws_s3_bucket_acl" "demo_bucket_acl" {
  bucket = aws_s3_bucket.demo_bucket.id
  acl    = "private"
}

# Configure bucket encryption with our own key
resource "aws_s3_bucket_server_side_encryption_configuration" "demo_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.demo_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.data_key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# Add a public access block for our bucket
resource "aws_s3_bucket_public_access_block" "demo_bucket_public_access_block" {
  bucket = aws_s3_bucket.demo_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
