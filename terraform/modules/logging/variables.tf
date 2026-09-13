# Project name used in bucket naming and tags.
variable "project_name" {
  description = "Project name used for logging resources."
  type        = string
}

# Environment name such as dev, staging or prod.
variable "environment" {
  description = "Environment name for the logging resources."
  type        = string
}

# AWS account ID is included in the bucket name so the name stays globally unique.
variable "aws_account_id" {
  description = "AWS account ID used to build a globally unique S3 bucket name."
  type        = string
}

# Number of days to keep ALB access logs before S3 automatically expires them.
# Each environment can choose a different retention period based on cost and audit needs.
variable "log_retention_days" {
  description = "Number of days to retain ALB access logs in S3."
  type        = number
}


