# Keep naming and tags consistent with the rest of the platform.
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  # S3 bucket names must be globally unique.
  # Including the AWS account ID makes collisions much less likely.
  alb_log_bucket_name = "${var.project_name}-${var.environment}-alb-logs-${var.aws_account_id}"
}
