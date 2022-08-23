/******************************
# Terragrunt outputs
******************************/

output "aws_s3_bucket_demo_bucket_name" {
    value = aws_s3_bucket.demo_bucket.id
}
