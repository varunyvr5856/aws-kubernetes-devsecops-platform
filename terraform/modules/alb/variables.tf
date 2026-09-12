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
