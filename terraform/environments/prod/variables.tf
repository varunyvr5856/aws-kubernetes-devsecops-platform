variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the dev environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the prod application tier."
  type        = string
}

variable "min_size" {
  description = "Minimum ASG size for prod."
  type        = number
}

variable "desired_capacity" {
  description = "Desired ASG capacity for prod."
  type        = number
}

variable "max_size" {
  description = "Maximum ASG size for prod."
  type        = number
}

# Environment-level switch for ALB deletion protection.
variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection on the environment ALB."
  type        = bool
}

# Controls how long ALB access logs are retained for this environment.
variable "alb_log_retention_days" {
  description = "Number of days to retain ALB access logs."
  type        = number
}

