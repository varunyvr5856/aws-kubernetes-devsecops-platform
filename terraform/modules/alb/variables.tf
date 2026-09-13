variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the Application Load Balancer."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the Application Load Balancer."
  type        = string
}

# Controls whether AWS protects the ALB from accidental deletion.
# We keep this configurable so non-production environments can be destroyed
# easily, while production can use an extra safety guard.
variable "enable_deletion_protection" {
  description = "Enable deletion protection on the Application Load Balancer."
  type        = bool
  default     = false
}
# Name of the S3 bucket where the ALB should write access logs.
# The logging module creates this bucket and passes its name into the ALB module.
variable "alb_log_bucket_name" {
  description = "S3 bucket name used for ALB access logs."
  type        = string
}

