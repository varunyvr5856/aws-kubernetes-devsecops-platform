output "target_group_arn" {
  description = "ARN of the application target group."
  value       = aws_lb_target_group.app.arn
}

output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.app.arn
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.app.dns_name
}
