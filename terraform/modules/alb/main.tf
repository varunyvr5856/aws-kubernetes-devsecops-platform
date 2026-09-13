resource "aws_lb" "app" {
  name               = "${var.environment}-app-alb"
  internal           = false
  load_balancer_type = "application"

  # Prevent accidental ALB deletion when enabled by the environment.
  # Production will enable this, while dev/staging keep it disabled so
  # those environments remain easy to tear down for cost control.

  enable_deletion_protection = var.enable_deletion_protection

  security_groups = [var.alb_security_group_id]
  subnets         = var.public_subnet_ids

  # Store request-level ALB access logs in our private logging bucket.
  access_logs {
    bucket  = var.alb_log_bucket_name
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-app-alb"
    Tier = "public"
  })
}

resource "aws_lb_target_group" "app" {
  name     = "${var.environment}-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-app-tg"
    Tier = "private"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
