variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "aws-kubernetes-devsecops-platform"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

