# Read the AWS account ID from the AWS credentials currently being used.
# This avoids hard-coding our AWS account number into the Terraform code.
data "aws_caller_identity" "current" {}

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "alb" {
  source = "../../modules/alb"
  # Pass the environment-specific deletion-protection setting into the ALB module.
  enable_deletion_protection = var.enable_alb_deletion_protection

  # Send ALB access logs to the S3 bucket created by the logging module.
  # The ALB module only needs the bucket name; the logging module owns the bucket.
  alb_log_bucket_name = module.logging.alb_log_bucket_name

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_sg_id
}

module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_security_group_id = module.security.app_sg_id
  instance_profile_name = module.iam.instance_profile_name
  target_group_arn      = module.alb.target_group_arn

  instance_type    = var.instance_type
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
}

# Create the logging resources for the dev environment.
# We pass the current AWS account ID to the logging module so it can
# build a globally unique name for the ALB access-log S3 bucket.
module "logging" {
  source = "../../modules/logging"

  project_name       = var.project_name
  environment        = var.environment
  aws_account_id     = data.aws_caller_identity.current.account_id
  log_retention_days = var.alb_log_retention_days
}
