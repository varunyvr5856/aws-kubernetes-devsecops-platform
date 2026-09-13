# Expose the bucket name so the ALB module can enable access logging to it.
output "alb_log_bucket_name" {
  description = "Name of the S3 bucket used for ALB access logs."
  value       = aws_s3_bucket.alb_logs.bucket
}

# Expose the bucket ARN for future IAM, monitoring or lifecycle configuration.
output "alb_log_bucket_arn" {
  description = "ARN of the S3 bucket used for ALB access logs."
  value       = aws_s3_bucket.alb_logs.arn
}
