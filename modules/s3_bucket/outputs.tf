output "main_s3_bucket_arn" {
  description = "main_s3_bucket"
  value = aws_s3_bucket.main_s3_bucket.arn
}

output "log_bucket_arn" {
  description = "log_bucket"
  value = aws_s3_bucket.log_bucket.arn
}

output "static_resource_s3_bucket_arn" {
  description = "static_resource_s3_bucket"
  value = aws_s3_bucket.static_resource_s3_bucket.arn
}