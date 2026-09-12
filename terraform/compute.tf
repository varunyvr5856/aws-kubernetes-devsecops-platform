module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_security_group_id = module.security.app_sg_id
  instance_profile_name = module.iam.instance_profile_name
  target_group_arn      = aws_lb_target_group.app.arn
}
