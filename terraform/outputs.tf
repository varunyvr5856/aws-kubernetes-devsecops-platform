output "vpc_id" {
  description = "ID of the platform VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = module.alb.load_balancer_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = module.alb.load_balancer_arn
}

output "target_group_arn" {
  description = "ARN of the application target group."
  value       = module.alb.target_group_arn
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group."
  value       = module.compute.autoscaling_group_name
}

output "launch_template_id" {
  description = "ID of the application Launch Template."
  value       = module.compute.launch_template_id
}
