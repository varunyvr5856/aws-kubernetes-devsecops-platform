output "alb_sg_id" {
  description = "Security group ID for the application load balancer."
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security group ID for the application tier."
  value       = aws_security_group.app.id
}
