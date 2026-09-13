# Security group for the public Application Load Balancer.
# The ALB is internet-facing, so it accepts HTTP traffic from the public internet.
resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for the application load balancer"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic from the internet.
  # We are keeping port 443 closed until we actually configure HTTPS on the ALB.
  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow the ALB to send traffic to downstream application targets.
  # We currently allow all outbound traffic because the ALB needs to reach
  # the private application instances on port 8080.
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
    Tier = "public"
  })
}

# Security group for the private application instances.
# These instances are not reachable directly from the internet.
resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Security group for application workloads"
  vpc_id      = var.vpc_id

  # Only allow application traffic from the ALB security group.
  # This prevents arbitrary internet clients from connecting directly to
  # the application instances on port 8080.
  ingress {
    description     = "Allow application traffic from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Allow application instances to make outbound connections.
  # This is currently needed for OS package updates, SSM access and other
  # outbound services reached through the NAT Gateway.
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-sg"
    Tier = "private"
  })
}
