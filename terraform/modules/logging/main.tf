# Create a dedicated S3 bucket for Application Load Balancer access logs.
# Each environment gets its own bucket so dev, staging and prod logs stay separated.
resource "aws_s3_bucket" "alb_logs" {
  bucket = local.alb_log_bucket_name

  tags = merge(local.common_tags, {
    Name = local.alb_log_bucket_name
    Tier = "logging"
  })
}

# Keep the log bucket completely private.
# ALB log delivery uses the bucket policy below, so the bucket does not need
# any form of public access.
resource "aws_s3_bucket_public_access_block" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Explicitly encrypt ALB access logs at rest using Amazon S3-managed keys.
# ALB access logging requires SSE-S3 for Application Load Balancer log delivery.
resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Disable ACL-based ownership and let the bucket owner own all objects.
# This keeps access management policy-based and simpler to reason about.
resource "aws_s3_bucket_ownership_controls" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Allow the AWS Elastic Load Balancing log-delivery service to write
# access-log objects into this bucket.
#
# The account ID is included in the object path so logs from another
# AWS account cannot be written into our expected log location.
resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowELBAccessLogDelivery"
        Effect = "Allow"

        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.alb_logs.arn}/AWSLogs/${var.aws_account_id}/*"
      }
    ]
  })

  # Make sure bucket security controls exist before Terraform attaches the policy.
  depends_on = [
    aws_s3_bucket_public_access_block.alb_logs,
    aws_s3_bucket_ownership_controls.alb_logs
  ]
}

# Keep S3 object versions so accidental overwrites or deletes are easier to recover from.
resource "aws_s3_bucket_versioning" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Automatically clean up old ALB access logs so the bucket does not grow forever.
# The retention period is controlled by each environment.
resource "aws_s3_bucket_lifecycle_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  rule {
    id     = "expire-old-alb-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = var.log_retention_days
    }

    # Old object versions can also accumulate when versioning is enabled.
    # Remove non-current versions after the same retention window.
    noncurrent_version_expiration {
      noncurrent_days = var.log_retention_days
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.alb_logs
  ]
}
