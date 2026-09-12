variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the Auto Scaling Group."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID attached to application instances."
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name attached to EC2 instances."
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN attached to the Auto Scaling Group."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the application."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 4
}
